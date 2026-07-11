import 'package:grpc/grpc.dart';
import '../../domain/repositories/speech_repository.dart';
import '../../services/generated/speech_analysis.pbgrpc.dart';
import '../network/grpc_auth_interceptor.dart';

import 'dart:io';

class GrpcSpeechRepository implements SpeechRepository {
  late ClientChannel _channel;
  late SpeechAnalysisServiceClient _stub;

  GrpcSpeechRepository() {
    _channel = ClientChannel(
      Platform.isAndroid ? '10.0.2.2' : 'localhost',
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
