namespace SpeakMate.Infrastructure.AiProviders;

public class AiSettings
{
    public const string SectionName = "AiSettings";

    /// <summary>
    /// Active provider name: "Gemini", "Groq", or "Mock"
    /// </summary>
    public string ActiveProvider { get; set; } = "Gemini";

    /// <summary>
    /// System prompt that defines the voice assistant persona.
    /// </summary>
    public string SystemPrompt { get; set; } =
        "You are SpeakMate, a helpful, intelligent, and friendly voice assistant. Answer concisely and clearly.";

    /// <summary>
    /// Extensible dictionary of AI provider configurations (ApiKey, Endpoint, ModelName).
    /// </summary>
    public Dictionary<string, ProviderConfig> Providers { get; set; } = new(StringComparer.OrdinalIgnoreCase);

    /// <summary>
    /// Helper method to retrieve the currently active provider's configuration safely.
    /// </summary>
    public ProviderConfig GetActiveProviderConfig()
    {
        if (Providers.TryGetValue(ActiveProvider, out var config))
        {
            return config;
        }

        return new ProviderConfig();
    }
}

public class ProviderConfig
{
    public string ApiKey { get; set; } = string.Empty;
    public string Endpoint { get; set; } = string.Empty;
    public string ModelName { get; set; } = string.Empty;
}
