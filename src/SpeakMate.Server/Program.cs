using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using SpeakMate.Application.Interfaces;
using SpeakMate.Application.Services;
using SpeakMate.Infrastructure.AiProviders;
using SpeakMate.Infrastructure.Auth;
using SpeakMate.Infrastructure.Data;
using SpeakMate.Infrastructure.Repositories;
using SpeakMate.Server.Services;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddGrpc();

// Add Dependency Injection
builder.Services.AddSingleton<IAiService, MockAiService>();
builder.Services.AddScoped<ISpeechProcessingService, SpeechProcessingService>();
builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<IAuthService, JwtAuthService>();

// Configure Entity Framework Core
builder.Services.AddDbContext<SpeakMateDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// Add JWT Authentication
var jwtSettings = builder.Configuration.GetSection("Jwt");
var key = Encoding.ASCII.GetBytes(jwtSettings["Key"]!);

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = jwtSettings["Issuer"],
        ValidAudience = jwtSettings["Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(key)
    };
});

builder.Services.AddAuthorization();

var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseAuthentication();
app.UseAuthorization();

app.MapGrpcService<AuthGrpcService>();
app.MapGrpcService<SpeechAnalyzerService>();

app.MapGet("/", () => "Communication with gRPC endpoints must be made through a gRPC client. To learn how to create a client, visit: https://go.microsoft.com/fwlink/?linkid=2086909");

await app.RunAsync();

//Test projemizin, ana sunucu projesine eriþebilmesi için 
public partial class Program 
{ 
    protected Program() { }
}
