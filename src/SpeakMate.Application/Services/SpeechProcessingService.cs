using SpeakMate.Application.Interfaces;

namespace SpeakMate.Application.Services
{
    public class SpeechProcessingService(IAiService aiService) : ISpeechProcessingService
    {
        private readonly IAiService _aiService = aiService;

		public async Task<string> ProcessSpeechAsync(string text, CancellationToken cancellationToken)
        {
            // In the future, this class can orchestrate multiple services (e.g., save to DB, translate, etc.)
            // For now, it just calls the AI service.
            return await _aiService.AnalyzeTextAsync(text, cancellationToken);
        }
    }
}
