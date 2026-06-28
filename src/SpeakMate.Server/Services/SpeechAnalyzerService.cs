using Grpc.Core;
using Microsoft.AspNetCore.Authorization;
using SpeakMate.Application.Interfaces;
using SpeakMate.Contracts;
using System.Text;

namespace SpeakMate.Server.Services
{
    [Authorize]
    public class SpeechAnalyzerService : SpeechAnalysisService.SpeechAnalysisServiceBase
    {
        private readonly ILogger<SpeechAnalyzerService> _logger;
        private readonly ISpeechProcessingService _speechProcessingService;

        public SpeechAnalyzerService(ILogger<SpeechAnalyzerService> logger, ISpeechProcessingService speechProcessingService)
        {
            _logger = logger;
            _speechProcessingService = speechProcessingService;
        }

        public override async Task AnalyzeStream(
            IAsyncStreamReader<AudioChunk> requestStream,
            IServerStreamWriter<AnalysisResult> responseStream,
            ServerCallContext context)
        {
            var user = context.GetHttpContext().User.Identity?.Name ?? "Unknown";
            _logger.LogInformation($"AnalyzeStream started for user {user}.");

            await foreach (var chunk in requestStream.ReadAllAsync())
            {
                _logger.LogInformation($"Received chunk of size {chunk.AudioData.Length} bytes for session {chunk.SessionId}.");

                // In a real app, we would transcribe audio to text here.
                // For now, let's mock the transcription:
                string transcribedText = "Mock transcribed text...";

                // Delegate business logic to the application service
                string aiResponse = await _speechProcessingService.ProcessSpeechAsync(transcribedText, context.CancellationToken);

                var result = new AnalysisResult
                {
                    Text = transcribedText,
                    AiResponse = aiResponse,
                    IsFinal = true
                };

                await responseStream.WriteAsync(result);
            }

            _logger.LogInformation($"AnalyzeStream finished for user {user}.");
        }
    }
}
