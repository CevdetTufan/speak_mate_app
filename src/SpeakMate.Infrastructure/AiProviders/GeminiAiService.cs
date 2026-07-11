using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SpeakMate.Application.Interfaces;
using System.Net.Http.Json;
using System.Text.Json.Nodes;

namespace SpeakMate.Infrastructure.AiProviders;

public class GeminiAiService(
    HttpClient httpClient,
    IOptions<AiSettings> options,
    ILogger<GeminiAiService> logger) : IAiService
{
    private readonly HttpClient _httpClient = httpClient;
    private readonly AiSettings _settings = options.Value;
    private readonly ILogger<GeminiAiService> _logger = logger;

    public async Task<string> AnalyzeTextAsync(string text, CancellationToken cancellationToken)
    {
        _settings.Providers.TryGetValue("Gemini", out var providerConfig);
        var apiKey = providerConfig?.ApiKey ?? string.Empty;
        if (string.IsNullOrWhiteSpace(apiKey))
        {
            _logger.LogWarning("Gemini API key is not configured. Falling back to mock notification message.");
            return "AI servis anahtarı yapılandırılmadı (Gemini API Key eksik). Lütfen User Secrets veya Environment Variable üzerinden AiSettings:Providers:Gemini:ApiKey değerini tanımlayın.";
        }

        var modelName = providerConfig != null && !string.IsNullOrWhiteSpace(providerConfig.ModelName) ? providerConfig.ModelName : "gemini-2.5-flash";
        var relativeUri = $"{modelName}:generateContent?key={apiKey}";

        var payload = new
        {
            system_instruction = new
            {
                parts = new { text = _settings.SystemPrompt }
            },
            contents = new[]
            {
                new
                {
                    parts = new[]
                    {
                        new { text }
                    }
                }
            }
        };

        try
        {
            if (_logger.IsEnabled(LogLevel.Information))
            {
                _logger.LogInformation("Sending request to Google Gemini API using model {ModelName}", modelName);
            }

            using var response = await _httpClient.PostAsJsonAsync(relativeUri, payload, cancellationToken);
            var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);

            if (!response.IsSuccessStatusCode)
            {
                _logger.LogError("Gemini API request failed with status {StatusCode}: {ErrorDetails}", response.StatusCode, responseContent);
                return "AI yanıtı alınamadı. Lütfen daha sonra tekrar deneyin.";
            }

            var jsonNode = JsonNode.Parse(responseContent);
            var answerText = jsonNode?["candidates"]?[0]?["content"]?["parts"]?[0]?["text"]?.GetValue<string>();

            if (string.IsNullOrWhiteSpace(answerText))
            {
                _logger.LogWarning("Gemini API returned empty response text.");
                return "Anladım, ancak şu anda size anlamlı bir yanıt üretemiyorum.";
            }

            _logger.LogInformation("Successfully received response from Gemini API.");
            return answerText.Trim();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while calling Google Gemini API.");
            return "AI servisiyle iletişim kurulurken bir hata oluştu.";
        }
    }
}
