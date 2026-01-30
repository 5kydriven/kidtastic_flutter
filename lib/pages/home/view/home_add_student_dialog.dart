import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../bloc/bloc.dart';

class HomeAddStudentDialog extends StatefulWidget {
  final HomeBloc homeBloc;

  const HomeAddStudentDialog({
    super.key,
    required this.homeBloc,
  });

  @override
  State<HomeAddStudentDialog> createState() =>
      _HomeAddStudentDialogState();
}

class _HomeAddStudentDialogState
    extends State<HomeAddStudentDialog> {
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
    final bloc = context.read<HomeBloc>();
    final state = bloc.state;
    bloc.add(const HomeSfxButtonPressed());
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
                              HomeAvatarSelected(
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
    required HomeState state,
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
    required HomeState state,
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
    required HomeState state,
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
    return BlocProvider<HomeBloc>.value(
      value: widget.homeBloc,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final bloc = context.read<HomeBloc>();

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
                    bloc.add(const HomeErrorTypeCleared());
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
                    bloc.add(const HomeAddStudentPressed());
                    return null;
                  },
                ),
              },
              child: Focus(
                autofocus: true,
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
                          'Add Student',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Create your profile to start learning and playing',
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 24,
                                    children: [
                                      Container(
                                        width: 84,
                                        height: 84,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(
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
                                  isRequired: true,
                                  onChanged: (value) => bloc.add(
                                    HomeFirstNameChanged(value: value),
                                  ),
                                  errorMessage: _firstNameErrorText(
                                    context: context,
                                    state: state,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                LabeledTextFormField(
                                  label: 'Last Name',
                                  isRequired: true,
                                  onChanged: (value) => bloc.add(
                                    HomeLastNameChanged(value: value),
                                  ),
                                  errorMessage: _lastNameErrorText(
                                    context: context,
                                    state: state,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                DropdownButtonFormField(
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
                                    HomeGenderChanged(
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
                              const HomeAddStudentPressed(),
                            ),
                            child: const Text("Let's Go!"),
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
                            bloc.add(const HomeErrorTypeCleared());
                            bloc.add(const HomeSfxButtonPressed());
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
          );
        },
      ),
    );
  }
}
