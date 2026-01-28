import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../constants/constants.dart';
import '../models/models.dart';

class OwlGuideTemplate extends StatefulWidget {
  final String message;

  const OwlGuideTemplate({super.key, required this.message});

  @override
  State<OwlGuideTemplate> createState() => _OwlGuideTemplateState();
}

class _OwlGuideTemplateState extends State<OwlGuideTemplate> {
  static const int maxCharsPerPage = 56;
  static const Duration typingSpeed = Duration(
    milliseconds: 50,
  );
  static const Duration pagePause = Duration(milliseconds: 600);

  final FlutterTts _tts = FlutterTts();

  late final List<String> _pages;
  int _currentPage = 0;
  String _displayedText = '';

  @override
  void initState() {
    super.initState();
    _pages = _splitMessage(widget.message);
    _initTts().then((_) => _typeCurrentPage());
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');

    final voices = await _tts.getVoices;
    try {
      final voiceList = (voices as List)
          .map((e) => Voices.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      final selected = voiceList.firstWhere(
        (v) => v.locale == 'en-US' && v.gender == 'female',
        orElse: () => voiceList.first,
      );

      await _tts.setVoice({
        'name': selected.name ?? '',
        'locale': selected.locale ?? '',
      });
    } catch (e) {
      debugPrint('Voice selection error: $e');
    }

    await _tts.setPitch(1.6); // Slightly high pitched for a cute owl
    await _tts.setSpeechRate(0.5); // Normal speaking pace
    await _tts.setVolume(1.0);
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
    if (buffer.trim().isNotEmpty) pages.add(buffer.trim());
    return pages;
  }

  Future<void> _typeCurrentPage() async {
    if (!mounted) return;

    _displayedText = '';
    final text = _pages[_currentPage];

    // Speak the entire page at once so the engine can pronounce words correctly
    await _tts.stop();
    _tts.speak(text);

    // Typing animation loop
    for (int i = 0; i < text.length; i++) {
      if (!mounted) return;

      setState(() {
        _displayedText += text[i];
      });

      await Future.delayed(typingSpeed);
    }

    // Wait for the pause duration before moving to next page
    await Future.delayed(pagePause);

    if (mounted && _currentPage < _pages.length - 1) {
      setState(() {
        _currentPage++;
      });
      _typeCurrentPage();
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(Assets.owl, width: 450),

          Positioned(
            left: 160,
            top: -100,
            child: Stack(
              children: [
                Image.asset(Assets.bubbleText, width: 300),
                Positioned(
                  right: 65,
                  top: 55,
                  child: Container(
                    width: 155,
                    height: 75,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      _displayedText,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.2,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
