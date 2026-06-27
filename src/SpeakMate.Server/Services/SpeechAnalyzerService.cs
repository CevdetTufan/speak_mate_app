using Grpc.Core;
using SpeakMate.Contracts;
using System.Text;

namespace SpeakMate.Server.Services
{
    public class SpeechAnalyzerService : SpeechAnalysisService.SpeechAnalysisServiceBase
    {
        private readonly ILogger<SpeechAnalyzerService> _logger;

        public SpeechAnalyzerService(ILogger<SpeechAnalyzerService> logger)
        {
            _logger = logger;
        }

        public override async Task AnalyzeStream(
            IAsyncStreamReader<AudioChunk> requestStream,
            IServerStreamWriter<AnalysisResult> responseStream,
            ServerCallContext context)
        {
            _logger.LogInformation("AnalyzeStream started.");

            // Loop to receive audio chunks
            await foreach (var chunk in requestStream.ReadAllAsync())
            {
                _logger.LogInformation($"Received chunk of size {chunk.AudioData.Length} bytes for session {chunk.SessionId}.");

                // Mocking the AI processing delay
                await Task.Delay(500);

                // Mock result
                var result = new AnalysisResult
                {
                    Text = "Mock transcription...",
                    AiResponse = "Mock AI response...",
                    IsFinal = true
                };

                await responseStream.WriteAsync(result);
            }

            _logger.LogInformation("AnalyzeStream finished.");
        }
    }
}
