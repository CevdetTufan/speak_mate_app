// This is a generated file - do not edit.
//
// Generated from speech_analysis.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use audioChunkDescriptor instead')
const AudioChunk$json = {
  '1': 'AudioChunk',
  '2': [
    {'1': 'audio_data', '3': 1, '4': 1, '5': 12, '10': 'audioData'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `AudioChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioChunkDescriptor = $convert.base64Decode(
    'CgpBdWRpb0NodW5rEh0KCmF1ZGlvX2RhdGEYASABKAxSCWF1ZGlvRGF0YRIdCgpzZXNzaW9uX2'
    'lkGAIgASgJUglzZXNzaW9uSWQ=');

@$core.Deprecated('Use analysisResultDescriptor instead')
const AnalysisResult$json = {
  '1': 'AnalysisResult',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'ai_response', '3': 2, '4': 1, '5': 9, '10': 'aiResponse'},
    {'1': 'is_final', '3': 3, '4': 1, '5': 8, '10': 'isFinal'},
  ],
};

/// Descriptor for `AnalysisResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List analysisResultDescriptor = $convert.base64Decode(
    'Cg5BbmFseXNpc1Jlc3VsdBISCgR0ZXh0GAEgASgJUgR0ZXh0Eh8KC2FpX3Jlc3BvbnNlGAIgAS'
    'gJUgphaVJlc3BvbnNlEhkKCGlzX2ZpbmFsGAMgASgIUgdpc0ZpbmFs');
