import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../bloc/bloc.dart';

class StudentEditBody extends StatefulWidget {
  const StudentEditBody({super.key});

  @override
  State<StudentEditBody> createState() => _StudentEditBodyState();
}

class _StudentEditBodyState extends State<StudentEditBody> {
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

  String? _firstNameErrorText({
    required BuildContext context,
    required StudentEditState state,
  }) {
    switch (state.firstName.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      default:
        return null;
    }
  }

  String? _lastNameErrorText({
    required BuildContext context,
    required StudentEditState state,
  }) {
    switch (state.lastName.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      default:
        return null;
    }
  }

  String? _genderErrorText({
    required BuildContext context,
    required StudentEditState state,
  }) {
    switch (state.gender.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentEditBloc, StudentEditState>(
      builder: (context, state) {
        final bloc = context.read<StudentEditBloc>();
        final student = state.student;

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
              child: Scaffold(
                backgroundColor: Colors.black54,
                body: Center(
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      width: 450,
                      height: 550,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Edit Student',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  CompositedTransformTarget(
                                    link: _layerLink,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      spacing: 24,
                                      children: [
                                        Container(
                                          width: 84,
                                          height: 84,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                student?.image ??
                                                    state.selectedAvatar,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        FilledButton(
                                          onPressed: () =>
                                              _toggleAvatarMenu(context),
                                          child: const Text('Choose Avatar'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  LabeledTextFormField(
                                    label: 'First Name',
                                    initialValue: student?.firstName ?? '',
                                    isRequired: true,
                                    onChanged: (value) => bloc.add(
                                      StudentEditFirstNameChanged(value: value),
                                    ),
                                    errorMessage: _firstNameErrorText(
                                      context: context,
                                      state: state,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  LabeledTextFormField(
                                    label: 'Last Name',
                                    initialValue: student?.lastName ?? '',
                                    isRequired: true,
                                    onChanged: (value) => bloc.add(
                                      StudentEditLastNameChanged(value: value),
                                    ),
                                    errorMessage: _lastNameErrorText(
                                      context: context,
                                      state: state,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  DropdownButtonFormField(
                                    value: student?.gender?.isNotEmpty == true
                                        ? student!.gender
                                        : null,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'male',
                                        child: Text('Male'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'female',
                                        child: Text('Female'),
                                      ),
                                    ],
                                    onChanged: (value) => bloc.add(
                                      StudentEditGenderChanged(
                                        value: value ?? '',
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      errorText: _genderErrorText(
                                        context: context,
                                        state: state,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            height: 44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => bloc.add(
                                const StudentEditSavePressed(),
                              ),
                              child: const Text('Save'),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                            ),
                            onPressed: () {
                              bloc.add(const StudentEditErrorTypeCleared());
                              bloc.add(const StudentEditSfxButtonPressed());
                              context.pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
