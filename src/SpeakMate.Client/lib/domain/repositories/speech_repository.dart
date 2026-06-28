import '../../services/generated/speech_analysis.pb.dart';

abstract class SpeechRepository {
  Stream<AnalysisResult> analyzeAudioStream(Stream<AudioChunk> requestStream);
}
