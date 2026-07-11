using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SpeakMate.Application.Interfaces;

namespace SpeakMate.Infrastructure.AiProviders;

public class GroqAiService(
    HttpClient httpClient,
    IOptions<AiSettings> options,
    ILogger<GroqAiService> logger) : IAiService
{
    private readonly HttpClient _httpClient = httpClient;
    private readonly AiSettings _settings = options.Value;
    private readonly ILogger<GroqAiService> _logger = logger;

    public async Task<string> AnalyzeTextAsync(string text, CancellationToken cancellationToken)
    {
        _settings.Providers.TryGetValue("Groq", out var providerConfig);
        var apiKey = providerConfig?.ApiKey ?? string.Empty;
        if (string.IsNullOrWhiteSpace(apiKey))
        {
            _logger.LogWarning("Groq API key is not configured. Falling back to mock notification message.");
            return "AI servis anahtarı yapılandırılmadı (Groq API Key eksik). Lütfen User Secrets veya Environment Variable üzerinden AiSettings:Providers:Groq:ApiKey değerini tanımlayın.";
        }

        var modelName = providerConfig != null && !string.IsNullOrWhiteSpace(providerConfig.ModelName) ? providerConfig.ModelName : "llama-3.3-70b-versatile";
        var requestMessage = new HttpRequestMessage(HttpMethod.Post, "");
        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);

        var payload = new
        {
            model = modelName,
            messages = new[]
            {
                new { role = "system", content = _settings.SystemPrompt },
                new { role = "user", content = text }
            },
            temperature = 0.7
        };

        requestMessage.Content = JsonContent.Create(payload);

        try
        {
            if (_logger.IsEnabled(LogLevel.Information))
            {
                _logger.LogInformation("Sending request to Groq API using model {ModelName}", modelName);
            }

            using var response = await _httpClient.SendAsync(requestMessage, cancellationToken);
            var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);

            if (!response.IsSuccessStatusCode)
            {
                _logger.LogError("Groq API request failed with status {StatusCode}: {ErrorDetails}", response.StatusCode, responseContent);
                return "AI yanıtı alınamadı. Lütfen daha sonra tekrar deneyin.";
            }

            var jsonNode = JsonNode.Parse(responseContent);
            var answerText = jsonNode?["choices"]?[0]?["message"]?["content"]?.GetValue<string>();

            if (string.IsNullOrWhiteSpace(answerText))
            {
                _logger.LogWarning("Groq API returned empty response text.");
                return "Anladım, ancak şu anda size anlamlı bir yanıt üretemiyorum.";
            }

            _logger.LogInformation("Successfully received response from Groq API.");
            return answerText.Trim();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while calling Groq API.");
            return "AI servisiyle iletişim kurulurken bir hata oluştu.";
        }
    }
}
