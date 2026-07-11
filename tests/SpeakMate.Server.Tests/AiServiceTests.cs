using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpeakMate.Application.Interfaces;
using SpeakMate.Infrastructure;

namespace SpeakMate.Server.Tests;

public class AiServiceTests
{
    [Fact]
    public async Task DelegatingAiService_WhenProviderIsMock_ReturnsMockResponse()
    {
        // Arrange
        var services = new ServiceCollection();
        services.AddLogging();

        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string?>
            {
                ["AiSettings:ActiveProvider"] = "Mock"
            })
            .Build();

        services.AddAiProviders(configuration);
        var provider = services.BuildServiceProvider();

        var aiService = provider.GetRequiredService<IAiService>();

        // Act
        var result = await aiService.AnalyzeTextAsync("Hello SpeakMate", CancellationToken.None);

        // Assert
        Assert.Contains("Mock AI response to: Hello SpeakMate", result);
    }

    [Fact]
    public async Task GeminiAiService_WhenApiKeyIsMissing_ReturnsFriendlyWarningMessageWithoutThrowing()
    {
        // Arrange
        var services = new ServiceCollection();
        services.AddLogging();

        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string?>
            {
                ["AiSettings:ActiveProvider"] = "Gemini",
                ["AiSettings:Providers:Gemini:ApiKey"] = "" // Empty key to ensure no crash
            })
            .Build();

        services.AddAiProviders(configuration);
        var provider = services.BuildServiceProvider();

        var aiService = provider.GetRequiredService<IAiService>();

        // Act
        var result = await aiService.AnalyzeTextAsync("Hello SpeakMate", CancellationToken.None);

        // Assert
        Assert.Contains("AI servis anahtarı yapılandırılmadı", result);
    }

    [Fact]
    public async Task GroqAiService_WhenApiKeyIsMissing_ReturnsFriendlyWarningMessageWithoutThrowing()
    {
        // Arrange
        var services = new ServiceCollection();
        services.AddLogging();

        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string?>
            {
                ["AiSettings:ActiveProvider"] = "Groq",
                ["AiSettings:Providers:Groq:ApiKey"] = ""
            })
            .Build();

        services.AddAiProviders(configuration);
        var provider = services.BuildServiceProvider();

        var aiService = provider.GetRequiredService<IAiService>();

        // Act
        var result = await aiService.AnalyzeTextAsync("Hello SpeakMate", CancellationToken.None);

        // Assert
        Assert.Contains("AI servis anahtarı yapılandırılmadı", result);
    }
}
