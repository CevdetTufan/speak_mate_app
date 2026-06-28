using Grpc.Net.Client;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.DependencyInjection;
using SpeakMate.Application.Interfaces;
using SpeakMate.Contracts;
using SpeakMate.Domain.Entities;

namespace SpeakMate.Server.Tests;

public class FakeUserRepository : IUserRepository
{
    private readonly List<User> _users = new();

    public Task<bool> CreateUserAsync(User user)
    {
        _users.Add(user);
        return Task.FromResult(true);
    }

    public Task<User?> GetUserByUsernameAsync(string username)
    {
        return Task.FromResult(_users.FirstOrDefault(u => u.Username == username));
    }
}

public class AuthIntegrationTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;

    public AuthIntegrationTests(WebApplicationFactory<Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureTestServices(services =>
            {
                // Remove the real repository
                var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(IUserRepository));
                if (descriptor != null)
                {
                    services.Remove(descriptor);
                }

                // Inject the fake repository
                services.AddSingleton<IUserRepository, FakeUserRepository>();
            });
        });
    }

    [Fact]
    public async Task Login_ShouldReturnToken_WhenCredentialsAreValid()
    {
        // Arrange
        var httpClient = _factory.CreateDefaultClient();
        var channel = GrpcChannel.ForAddress(httpClient.BaseAddress!, new GrpcChannelOptions
        {
            HttpClient = httpClient
        });
        
        var authClient = new AuthService.AuthServiceClient(channel);

        // Act
        var request = new RegisterRequest { Username = "testuser", Password = "password" };
        await authClient.RegisterAsync(request);

        var loginReq = new LoginRequest { Username = "testuser", Password = "password" };
        var response = await authClient.LoginAsync(loginReq);

        // Assert
        Assert.NotNull(response.Token);
        Assert.False(string.IsNullOrEmpty(response.Token));
    }
}
