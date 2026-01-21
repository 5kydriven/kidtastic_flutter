import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../constants/constants.dart';

class OwlGuideTemplate extends StatefulWidget {
  final String message;

  const OwlGuideTemplate({
    super.key,
    required this.message,
  });

  @override
  State<OwlGuideTemplate> createState() => _OwlGuideTemplateState();
}

class _OwlGuideTemplateState extends State<OwlGuideTemplate> {
  // ✅ CALIBRATED FOR YOUR BUBBLE
  static const int maxCharsPerPage = 56;
  static const Duration typingSpeed = Duration(milliseconds: 40);
  static const Duration pagePause = Duration(milliseconds: 450);

  late final List<String> _pages;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pages = _splitMessage(widget.message);
  }

  List<String> _splitMessage(String text) {
    final words = text.split(' ');
    final pages = <String>[];

    String buffer = '';

    for (final word in words) {
      if ((buffer + word).length > maxCharsPerPage) {
        pages.add(buffer.trim());
        buffer = '$word ';
      } else {
        buffer += '$word ';
      }
    }

    if (buffer.trim().isNotEmpty) {
      pages.add(buffer.trim());
    }

    return pages;
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      Future.delayed(pagePause, () {
        if (!mounted) return;
        setState(() {
          _currentPage++;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          Assets.owl,
          width: 450,
        ),

        Positioned(
          left: 160,
          top: -100,
          child: Stack(
            children: [
              Image.asset(
                Assets.bubbleText,
                width: 300,
              ),
              Positioned(
                right: 65,
                top: 55,
                child: Container(
                  width: 155,
                  height: 75,
                  padding: const EdgeInsets.all(8),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.2,
                      color: Colors.black,
                    ),
                    child: AnimatedTextKit(
                      key: ValueKey(_currentPage),
                      isRepeatingAnimation: false,
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          _pages[_currentPage],
                          speed: typingSpeed,
                          cursor: '|',
                        ),
                      ],
                      onFinished: _nextPage,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
