using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using SpeakMate.Application.Interfaces;
using SpeakMate.Infrastructure.AiProviders;

namespace SpeakMate.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddAiProviders(this IServiceCollection services, IConfiguration configuration)
    {
        services.Configure<AiSettings>(configuration.GetSection(AiSettings.SectionName));

        services.AddHttpClient<GeminiAiService>((sp, client) =>
        {
            var settings = sp.GetRequiredService<IOptions<AiSettings>>().Value;
            var baseUrl = settings.Providers.TryGetValue("Gemini", out var cfg) && !string.IsNullOrWhiteSpace(cfg.Endpoint)
                ? cfg.Endpoint
                : "https://generativelanguage.googleapis.com/v1beta/models/";
            client.BaseAddress = new Uri(baseUrl);
        });

        services.AddHttpClient<GroqAiService>((sp, client) =>
        {
            var settings = sp.GetRequiredService<IOptions<AiSettings>>().Value;
            var baseUrl = settings.Providers.TryGetValue("Groq", out var cfg) && !string.IsNullOrWhiteSpace(cfg.Endpoint)
                ? cfg.Endpoint
                : "https://api.groq.com/openai/v1/chat/completions";
            client.BaseAddress = new Uri(baseUrl);
        });

        services.AddScoped<MockAiService>();
        services.AddScoped<IAiService, DelegatingAiService>();

        return services;
    }
}
