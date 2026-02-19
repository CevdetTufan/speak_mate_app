import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../widgets/sound_wave_animation.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
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
          _isListening = false;
        });
        _pulseController.stop();
        _pulseController.reset();
      },
      onStatus: (status) {
        if (status == 'notListening' || status == 'done') {
          setState(() {
            _isListening = false;
          });
          _pulseController.stop();
          _pulseController.reset();
        }
      },
    );
    setState(() {});
  }

  void _startListening() async {
    if (!_isInitialized) return;

    setState(() {
      _isListening = true;
      _recognizedText = '';
      _currentPartial = '';
    });

    _pulseController.repeat(reverse: true);

    await _speech.listen(
      onResult: (result) {
        setState(() {
          if (result.finalResult) {
            _recognizedText = result.recognizedWords;
            _currentPartial = '';
          } else {
            _currentPartial = result.recognizedWords;
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
      _isListening = false;
    });
  }

  void _toggleListening() {
    if (_isListening) {
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

  String get _displayText {
    if (_currentPartial.isNotEmpty) return _currentPartial;
    if (_recognizedText.isNotEmpty) return _recognizedText;
    return '';
  }

  @override
  Widget build(BuildContext context) {
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
                  SoundWaveAnimation(isAnimating: _isListening),

                  const SizedBox(height: 40),

                  // Tanınan metin
                  _buildRecognizedText(),

                  const Spacer(flex: 3),

                  // Mikrofon butonu
                  _buildMicButton(),

                  const SizedBox(height: 12),

                  // Alt yazı
                  Text(
                    _isListening ? 'TAP TO PAUSE' : 'TAP TO SPEAK',
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
          // Kapat butonu
          IconButton(
            onPressed: () {
              // İleride geri navigasyon eklenecek
            },
            icon: Icon(
              Icons.close,
              color: Colors.white.withValues(alpha: 0.7),
              size: 24,
            ),
          ),

          // Başlık
          Expanded(
            child: Column(
              children: [
                Text(
                  _isListening ? 'AI IS LISTENING...' : 'SPEAK MATE',
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

          // Ayarlar butonu
          IconButton(
            onPressed: () {
              // İleride ayarlar ekranı eklenecek
            },
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

  Widget _buildRecognizedText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(
          _displayText.isEmpty
              ? (_isListening
                    ? 'Listening...'
                    : 'Tap the microphone to start speaking')
              : '"$_displayText"',
          key: ValueKey<String>(_displayText),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _displayText.isEmpty
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.7),
            fontSize: _displayText.isEmpty ? 16 : 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w300,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: _toggleListening,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          final scale = _isListening ? _pulseAnimation.value : 1.0;
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
                    blurRadius: _isListening ? 30 : 15,
                    spreadRadius: _isListening ? 5 : 2,
                  ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
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
