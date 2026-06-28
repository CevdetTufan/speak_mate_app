import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/speech_repository.dart';
import '../../data/repositories/grpc_speech_repository.dart';
import '../../services/generated/speech_analysis.pb.dart';

final speechRepositoryProvider = Provider<SpeechRepository>((ref) {
  return GrpcSpeechRepository();
});

class SpeechState {
  final String text;
  final String aiResponse;
  final bool isListening;

  SpeechState({this.text = '', this.aiResponse = '', this.isListening = false});

  SpeechState copyWith({String? text, String? aiResponse, bool? isListening}) {
    return SpeechState(
      text: text ?? this.text,
      aiResponse: aiResponse ?? this.aiResponse,
      isListening: isListening ?? this.isListening,
    );
  }
}

class SpeechNotifier extends StateNotifier<SpeechState> {
  final SpeechRepository _repository;

  SpeechNotifier(this._repository) : super(SpeechState());

  void setLocalText(String text) {
    state = state.copyWith(text: text);
  }

  void processWithAi(String text) {
    state = state.copyWith(isListening: true, text: text, aiResponse: 'Thinking...');

    // Send a single dummy chunk to represent the text
    // In a real app, you would stream audio bytes
    final requestStream = Stream.fromIterable([
      AudioChunk()
        ..audioData = [1, 2, 3] // dummy bytes
        ..sessionId = 'session-123'
    ]);

    final responseStream = _repository.analyzeAudioStream(requestStream);

    responseStream.listen(
      (result) {
        state = state.copyWith(
          aiResponse: result.aiResponse,
        );
        if (result.isFinal) {
          state = state.copyWith(isListening: false);
        }
      },
      onError: (e) {
        state = state.copyWith(isListening: false, aiResponse: 'Error: $e');
      },
      onDone: () {
        state = state.copyWith(isListening: false);
      },
    );
  }

  void stopListening() {
    state = state.copyWith(isListening: false);
  }
}

final speechProvider = StateNotifierProvider<SpeechNotifier, SpeechState>((ref) {
  final repository = ref.watch(speechRepositoryProvider);
  return SpeechNotifier(repository);
});
