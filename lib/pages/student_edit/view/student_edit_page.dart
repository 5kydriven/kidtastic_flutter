import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../bloc/bloc.dart';
import 'student_edit_body.dart';

class StudentEditPage extends StatefulWidget {
  static const String route = '/student/edit';
  final StudentEditState initialState;

  const StudentEditPage({
    super.key,
    required this.initialState,
  });

  @override
  State<StudentEditPage> createState() => _StudentEditPageState();
}

class _StudentEditPageState extends State<StudentEditPage> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  final List<String> avatars = [
    Assets.bearAvatar,
    Assets.birdAvatar,
    Assets.bullAvatar,
    Assets.catAvatar,
    Assets.crocodileAvatar,
    Assets.dogAvatar,
    Assets.frogAvatar,
    Assets.hedgehogAvatar,
    Assets.jellyfishAvatar,
    Assets.koalaAvatar,
    Assets.lionAvatar,
    Assets.miceAvatar,
    Assets.monkeyAvatar,
    Assets.pandaAvatar,
    Assets.rabbitAvatar,
    Assets.sharkAvatar,
    Assets.sheepAvatar,
    Assets.whaleAvatar,
    Assets.zebraAvatar,
  ];

  void _toggleAvatarMenu(BuildContext context) {
    final bloc = context.read<StudentEditBloc>();
    final state = bloc.state;
    bloc.add(const StudentEditSfxButtonPressed());
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      return;
    }

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
              child: const SizedBox(),
            ),
          ),
          Positioned(
            width: 300,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 100),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 220,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: avatars.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) {
                        final avatar = avatars[index];
                        final isSelected = avatar == state.selectedAvatar;

                        return GestureDetector(
                          onTap: () {
                            bloc.add(
                              StudentEditAvatarSelected(
                                avatar: avatar,
                              ),
                            );
                            _overlayEntry?.remove();
                            _overlayEntry = null;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blueAccent
                                    : Colors.transparent,
                                width: 3,
                              ),
                              image: DecorationImage(
                                image: AssetImage(avatar),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _studentListener(BuildContext context, StudentEditState state) {
    switch (state.studentRequestStatus) {
      case RequestStatus.inProgress:
        Center(
          child: CircularProgressIndicator(),
        );
        break;
      case RequestStatus.success:
        context.pop();
        state.onSave?.call();
        break;
      case RequestStatus.failure:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Something went wrong please try again',
              style: const TextStyle(fontSize: 20),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(
              milliseconds: 2500,
            ),
          ),
        );
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentEditBloc>(
      create: (context) => StudentEditBloc(
        initialState: widget.initialState,
        studentRepository: RepositoryProvider.of<StudentRepository>(context),
      ),
      child: BlocConsumer<StudentEditBloc, StudentEditState>(
        listenWhen: (previous, current) =>
            previous.studentRequestStatus != current.studentRequestStatus,
        listener: _studentListener,
        builder: (context, state) {
          final bloc = context.read<StudentEditBloc>();
          final state = bloc.state;

          return Shortcuts(
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.escape): const DismissIntent(),
              LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
              LogicalKeySet(LogicalKeyboardKey.numpadEnter):
                  const ActivateIntent(),
            },
            child: Actions(
              actions: {
                DismissIntent: CallbackAction<DismissIntent>(
                  onInvoke: (intent) {
                    bloc.add(const StudentEditErrorTypeCleared());
                    context.pop();
                    return null;
                  },
                ),
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (_) {
                    if (state.studentRequestStatus ==
                        RequestStatus.inProgress) {
                      return null;
                    }
                    bloc.add(const StudentEditSavePressed());
                    return null;
                  },
                ),
              },
              child: Focus(
                autofocus: true,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: StudentEditBody(
                    layerLink: _layerLink,
                    toggleAvatarMenu: () => _toggleAvatarMenu(context),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
