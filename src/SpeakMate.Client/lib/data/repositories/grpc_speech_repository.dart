import 'package:grpc/grpc.dart';
import '../../domain/repositories/speech_repository.dart';
import '../../services/generated/speech_analysis.pbgrpc.dart';
import '../network/grpc_auth_interceptor.dart';

class GrpcSpeechRepository implements SpeechRepository {
  late ClientChannel _channel;
  late SpeechAnalysisServiceClient _stub;

  GrpcSpeechRepository() {
    _channel = ClientChannel(
      'localhost',
      port: 5001,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _stub = SpeechAnalysisServiceClient(
      _channel,
      interceptors: [GrpcAuthInterceptor()],
    );
  }

  @override
  Stream<AnalysisResult> analyzeAudioStream(Stream<AudioChunk> requestStream) {
    return _stub.analyzeStream(requestStream);
  }
}
