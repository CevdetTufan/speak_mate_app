import 'package:grpc/grpc.dart';
// Note: In a real environment, you must run protoc to generate these files.
// import '../generated/speech_analysis.pbgrpc.dart';

class GrpcService {
  late ClientChannel _channel;
  // late SpeechAnalysisServiceClient _stub;

  GrpcService() {
    _channel = ClientChannel(
      'localhost', // Your gRPC server address
      port: 5001, // Your gRPC server port
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    // _stub = SpeechAnalysisServiceClient(_channel);
  }

  /*
  Stream<AnalysisResult> analyzeAudioStream(Stream<AudioChunk> requestStream) {
    return _stub.analyzeStream(requestStream);
  }
  */

  Future<void> dispose() async {
    await _channel.shutdown();
  }
}
