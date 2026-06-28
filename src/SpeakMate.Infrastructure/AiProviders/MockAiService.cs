using SpeakMate.Application.Interfaces;

namespace SpeakMate.Infrastructure.AiProviders
{
    public class MockAiService : IAiService
    {
        public async Task<string> AnalyzeTextAsync(string text, CancellationToken cancellationToken)
        {
            // Simulate AI processing delay
            await Task.Delay(500, cancellationToken);
            return $"Mock AI response to: {text}";
        }
    }
}
