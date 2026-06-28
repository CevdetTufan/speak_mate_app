// This is a generated file - do not edit.
//
// Generated from speech_analysis.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'speech_analysis.pb.dart' as $0;

export 'speech_analysis.pb.dart';

@$pb.GrpcServiceName('speech_analysis.SpeechAnalysisService')
class SpeechAnalysisServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SpeechAnalysisServiceClient(super.channel,
      {super.options, super.interceptors});

  /// Bi-directional stream for analyzing audio on the fly
  $grpc.ResponseStream<$0.AnalysisResult> analyzeStream(
    $async.Stream<$0.AudioChunk> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$analyzeStream, request, options: options);
  }

  // method descriptors

  static final _$analyzeStream =
      $grpc.ClientMethod<$0.AudioChunk, $0.AnalysisResult>(
          '/speech_analysis.SpeechAnalysisService/AnalyzeStream',
          ($0.AudioChunk value) => value.writeToBuffer(),
          $0.AnalysisResult.fromBuffer);
}

@$pb.GrpcServiceName('speech_analysis.SpeechAnalysisService')
abstract class SpeechAnalysisServiceBase extends $grpc.Service {
  $core.String get $name => 'speech_analysis.SpeechAnalysisService';

  SpeechAnalysisServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.AudioChunk, $0.AnalysisResult>(
        'AnalyzeStream',
        analyzeStream,
        true,
        true,
        ($core.List<$core.int> value) => $0.AudioChunk.fromBuffer(value),
        ($0.AnalysisResult value) => value.writeToBuffer()));
  }

  $async.Stream<$0.AnalysisResult> analyzeStream(
      $grpc.ServiceCall call, $async.Stream<$0.AudioChunk> request);
}
