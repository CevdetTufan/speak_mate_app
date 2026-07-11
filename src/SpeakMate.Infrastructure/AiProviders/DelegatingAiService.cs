using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SpeakMate.Application.Interfaces;

namespace SpeakMate.Infrastructure.AiProviders;

public class DelegatingAiService(
    IServiceProvider serviceProvider,
    IOptions<AiSettings> options,
    ILogger<DelegatingAiService> logger) : IAiService
{
    private readonly IServiceProvider _serviceProvider = serviceProvider;
    private readonly AiSettings _settings = options.Value;
    private readonly ILogger<DelegatingAiService> _logger = logger;

    public async Task<string> AnalyzeTextAsync(string text, CancellationToken cancellationToken)
    {
        var provider = _settings.ActiveProvider.Trim();
        if (_logger.IsEnabled(LogLevel.Information))
        {
            _logger.LogInformation("Using AI Provider: {Provider}", provider);
        }

        if (provider.Equals("Gemini", StringComparison.OrdinalIgnoreCase))
        {
            var geminiService = _serviceProvider.GetRequiredService<GeminiAiService>();
            return await geminiService.AnalyzeTextAsync(text, cancellationToken);
        }
        else if (provider.Equals("Groq", StringComparison.OrdinalIgnoreCase))
        {
            var groqService = _serviceProvider.GetRequiredService<GroqAiService>();
            return await groqService.AnalyzeTextAsync(text, cancellationToken);
        }
        else
        {
            var mockService = _serviceProvider.GetRequiredService<MockAiService>();
            return await mockService.AnalyzeTextAsync(text, cancellationToken);
        }
    }
}
