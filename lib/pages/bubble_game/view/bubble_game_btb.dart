import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/models.dart';
import '../bloc/bloc.dart';

class BubbleGameBtb extends StatefulWidget {
  const BubbleGameBtb({super.key});

  @override
  State<BubbleGameBtb> createState() => _BubbleGameBtbState();
}

class _BubbleGameBtbState extends State<BubbleGameBtb>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _pulseController;
  late AnimationController _soundWaveController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _soundWaveAnimation1;
  late Animation<double> _soundWaveAnimation2;
  late Animation<double> _soundWaveAnimation3;

  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _bounceAnimation =
        Tween<double>(
          begin: 0,
          end: -8,
        ).animate(
          CurvedAnimation(
            parent: _bounceController,
            curve: Curves.easeInOut,
          ),
        );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation =
        Tween<double>(
          begin: 1.0,
          end: 1.15,
        ).animate(
          CurvedAnimation(
            parent: _pulseController,
            curve: Curves.easeInOut,
          ),
        );

    _soundWaveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _soundWaveAnimation1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _soundWaveController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _soundWaveAnimation2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _soundWaveController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    _soundWaveAnimation3 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _soundWaveController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _pulseController.dispose();
    _soundWaveController.dispose();
    super.dispose();
  }

  void _handleTap(BubbleGameBloc bloc, String question, bool isSpeaking) {
    if (isSpeaking ||
        bloc.state.sessionQuestionRequestStatus == RequestStatus.inProgress) {
      return;
    }

    setState(() => _isPressed = true);
    bloc.add(BubbleGameTextSpeech(text: question));

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _isPressed = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BubbleGameBloc, BubbleGameState>(
      builder: (context, state) {
        final bloc = context.read<BubbleGameBloc>();
        final question = state.question[state.currentIndex];
        final isSpeaking = state.isSpeaking;

        if (isSpeaking) {
          _soundWaveController.repeat();
        } else {
          _soundWaveController.stop();
          _soundWaveController.reset();
        }

        return MouseRegion(
          cursor: isSpeaking
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          onEnter: (_) =>
              !isSpeaking ? setState(() => _isHovered = true) : null,
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _bounceAnimation,
              _pulseAnimation,
              _soundWaveController,
            ]),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, isSpeaking ? 0 : _bounceAnimation.value),
                child: Transform.scale(
                  scale: isSpeaking
                      ? 1.0
                      : _isPressed
                      ? 0.9
                      : _isHovered
                      ? 1.1
                      : _pulseAnimation.value,
                  child: child,
                ),
              );
            },
            child: GestureDetector(
              onTap: isSpeaking
                  ? null
                  : () => _handleTap(bloc, question.question ?? '', isSpeaking),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  // Gradient changes when speaking
                  gradient: isSpeaking
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF4A4A8A), // Darker purple (disabled look)
                            Color(0xFF008B8B), // Darker cyan
                          ],
                        )
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF6C5CE7), // Soft purple
                            Color(0xFF00D2D3), // Bright cyan
                          ],
                        ),
                  // Large rounded corners for playful look
                  borderRadius: BorderRadius.circular(50),
                  // White border for definition
                  border: Border.all(
                    color: isSpeaking
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.white,
                    width: 4,
                  ),
                  // Multiple shadows for depth and pop
                  boxShadow: isSpeaking
                      ? [
                          // Subtle shadow when speaking
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          // Inner glow
                          BoxShadow(
                            color: const Color(
                              0xFF6C5CE7,
                            ).withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                          // Drop shadow
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                          // Highlight shadow
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, -4),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Speaker icon with sound wave animation
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Sound wave circles when speaking
                        if (isSpeaking) ...[
                          _buildSoundWaveCircle(_soundWaveAnimation1, 50),
                          _buildSoundWaveCircle(_soundWaveAnimation2, 65),
                          _buildSoundWaveCircle(_soundWaveAnimation3, 80),
                        ],
                        // Speaker icon container
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: isSpeaking ? 0.2 : 0.3,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: isSpeaking
                                ? const Icon(
                                    Icons.volume_up_rounded,
                                    color: Colors.white70,
                                    size: 32,
                                    key: ValueKey('speaking'),
                                  )
                                : const Icon(
                                    Icons.volume_up_rounded,
                                    color: Colors.white,
                                    size: 32,
                                    key: ValueKey('idle'),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Text label
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            isSpeaking ? '🔊 Listening...' : 'Tap to Listen!',
                            key: ValueKey(isSpeaking),
                            style: TextStyle(
                              color: isSpeaking ? Colors.white70 : Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              shadows: isSpeaking
                                  ? null
                                  : const [
                                      Shadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                            ),
                          ),
                        ),
                        // Subtext
                        Text(
                          isSpeaking
                              ? '🎵 Audio playing...'
                              : '🔊 Hear the question',
                          style: TextStyle(
                            color: isSpeaking
                                ? Colors.white.withValues(alpha: 0.6)
                                : Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSoundWaveCircle(Animation<double> animation, double maxSize) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final size = maxSize * animation.value;
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: (1 - animation.value) * 0.3),
          ),
        );
      },
    );
  }
}
