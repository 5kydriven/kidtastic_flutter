import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../bloc/bloc.dart';

class InitialScreenAddStudentDialog extends StatefulWidget {
  final InitialScreenBloc initialScreenBloc;

  const InitialScreenAddStudentDialog({
    super.key,
    required this.initialScreenBloc,
  });

  @override
  State<InitialScreenAddStudentDialog> createState() =>
      _InitialScreenAddStudentDialogState();
}

class _InitialScreenAddStudentDialogState
    extends State<InitialScreenAddStudentDialog> {
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

  String selectedAvatar = Assets.sheepAvatar;

  bool showAvatars = false;

  // Add this inside your State class:
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleAvatarMenu(BuildContext context) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      return;
    }

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Transparent layer to detect outside taps
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
              child: const SizedBox(), // just a transparent clickable area
            ),
          ),

          // The actual floating avatar grid
          Positioned(
            width: 300,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 100), // distance below button
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 220, // limit popup height so it can scroll
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
                        final isSelected = avatar == selectedAvatar;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAvatar = avatar;
                            });
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

  String? _nameErrorText({
    required BuildContext context,
    required InitialScreenState state,
  }) {
    switch (state.name?.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InitialScreenBloc>.value(
      value: widget.initialScreenBloc,
      child: BlocBuilder<InitialScreenBloc, InitialScreenState>(
        builder: (context, state) {
          final bloc = context.read<InitialScreenBloc>();

          return Shortcuts(
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.escape): const DismissIntent(),
            },
            child: Actions(
              actions: {
                DismissIntent: CallbackAction<DismissIntent>(
                  onInvoke: (intent) {
                    context.pop();
                    return null;
                  },
                ),
              },
              child: Focus(
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: 400,
                    height: 500,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 20,
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
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(selectedAvatar),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => _toggleAvatarMenu(context),
                                child: const Text('Choose Avatar'),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Name',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              onChanged: (value) => bloc.add(
                                InitialScreenNameChanged(
                                  value: value,
                                ),
                              ),
                              autofocus: true,
                              onFieldSubmitted: (_) {
                                bloc.add(
                                  const InitialScreenAddStudentPressed(),
                                );
                                context.pop();
                              },
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                errorText: _nameErrorText(
                                  context: context,
                                  state: state,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 44,
                          padding: EdgeInsets.symmetric(
                            horizontal: 44,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              bloc.add(const InitialScreenAddStudentPressed());
                              context.pop();
                            },
                            child: const Text("Let's Go!"),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () => context.pop(),
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
