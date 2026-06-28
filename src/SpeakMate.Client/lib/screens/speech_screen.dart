import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../localization/app_locale.dart';
import '../widgets/sound_wave_animation.dart';
import '../presentation/providers/speech_provider.dart';
import '../presentation/providers/auth_provider.dart';

class SpeechScreen extends ConsumerStatefulWidget {
  const SpeechScreen({super.key});

  @override
  ConsumerState<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends ConsumerState<SpeechScreen>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListeningLocal = false;
  bool _isInitialized = false;
  String _recognizedText = '';
  String _currentPartial = '';
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _isInitialized = await _speech.initialize(
      onError: (error) {
        setState(() {
          _isListeningLocal = false;
        });
        _pulseController.stop();
        _pulseController.reset();
      },
      onStatus: (status) {
        if (status == 'notListening' || status == 'done') {
          setState(() {
            _isListeningLocal = false;
          });
          _pulseController.stop();
          _pulseController.reset();
          
          if (_recognizedText.isNotEmpty) {
            // Trigger AI processing
            ref.read(speechProvider.notifier).processWithAi(_recognizedText);
          }
        }
      },
    );
    setState(() {});
  }

  void _startListening() async {
    if (!_isInitialized) return;

    setState(() {
      _isListeningLocal = true;
      _recognizedText = '';
      _currentPartial = '';
    });
    
    ref.read(speechProvider.notifier).setLocalText('');

    _pulseController.repeat(reverse: true);

    await _speech.listen(
      onResult: (result) {
        setState(() {
          if (result.finalResult) {
            _recognizedText = result.recognizedWords;
            _currentPartial = '';
            ref.read(speechProvider.notifier).setLocalText(_recognizedText);
          } else {
            _currentPartial = result.recognizedWords;
            ref.read(speechProvider.notifier).setLocalText(_currentPartial);
          }
        });
      },
      localeId: 'en_US',
      listenOptions: stt.SpeechListenOptions(
        listenMode: stt.ListenMode.dictation,
        cancelOnError: false,
        partialResults: true,
      ),
    );
  }

  void _stopListening() async {
    await _speech.stop();
    _pulseController.stop();
    _pulseController.reset();
    setState(() {
      _isListeningLocal = false;
    });
  }

  void _toggleListening() {
    if (_isListeningLocal) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final speechState = ref.watch(speechProvider);
    final isProcessing = speechState.isListening;
    final displayAiResponse = speechState.aiResponse;
    final displayText = speechState.text;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Üst bar
            _buildTopBar(),

            // Ana içerik
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Ses dalgası animasyonu
                  SoundWaveAnimation(isAnimating: _isListeningLocal || isProcessing),

                  const SizedBox(height: 40),

                  // Tanınan metin
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      displayText.isEmpty 
                        ? (_isListeningLocal ? AppLocale.strings.listening : AppLocale.strings.tapMicToStart)
                        : '"$displayText"',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: displayText.isEmpty ? Colors.white30 : Colors.white70,
                        fontSize: displayText.isEmpty ? 16 : 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  
                  // AI Response
                  if (displayAiResponse.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          displayAiResponse,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  const Spacer(flex: 3),

                  // Mikrofon butonu
                  _buildMicButton(),

                  const SizedBox(height: 12),

                  // Alt yazı
                  Text(
                    _isListeningLocal
                        ? AppLocale.strings.tapToPause
                        : AppLocale.strings.tapToSpeak,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white.withValues(alpha: 0.7),
              size: 24,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  _isListeningLocal
                      ? AppLocale.strings.aiIsListening
                      : AppLocale.strings.appName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings_outlined,
              color: Colors.white.withValues(alpha: 0.7),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: _toggleListening,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          final scale = _isListeningLocal ? _pulseAnimation.value : 1.0;
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00E5FF), Color(0xFF00B8D4)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00B8D4).withValues(alpha: 0.4),
                    blurRadius: _isListeningLocal ? 30 : 15,
                    spreadRadius: _isListeningLocal ? 5 : 2,
                  ),
                ],
              ),
              child: Icon(
                _isListeningLocal ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 36,
              ),
            ),
          );
        },
      ),
    );
  }
}
