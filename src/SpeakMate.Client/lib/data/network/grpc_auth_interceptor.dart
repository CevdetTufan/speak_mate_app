import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GrpcAuthInterceptor implements ClientInterceptor {
  @override
  ResponseFuture<R> interceptUnary<Q, R>(
      ClientMethod<Q, R> method, Q request, CallOptions options, ClientUnaryInvoker<Q, R> invoker) {
    return invoker(method, request, options.mergedWith(CallOptions(providers: [_provider])));
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
      ClientMethod<Q, R> method, Stream<Q> requests, CallOptions options, ClientStreamingInvoker<Q, R> invoker) {
    return invoker(method, requests, options.mergedWith(CallOptions(providers: [_provider])));
  }

  Future<void> _provider(Map<String, String> metadata, String uri) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      metadata['authorization'] = 'Bearer $token';
    }
  }
}
