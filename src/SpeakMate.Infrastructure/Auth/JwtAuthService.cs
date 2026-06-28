using Microsoft.IdentityModel.Tokens;
using Microsoft.Extensions.Configuration;
using SpeakMate.Application.Interfaces;
using SpeakMate.Domain.Entities;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace SpeakMate.Infrastructure.Auth;

public class JwtAuthService(IConfiguration configuration, IUserRepository userRepository) : IAuthService
{
    public string GenerateJwtToken(string username)
    {
        var jwtSettings = configuration.GetSection("Jwt");
        var key = Encoding.ASCII.GetBytes(jwtSettings["Key"]!);

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(
            [
                new Claim(JwtRegisteredClaimNames.Sub, username),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            ]),
            Expires = DateTime.UtcNow.AddDays(7),
            Issuer = jwtSettings["Issuer"],
            Audience = jwtSettings["Audience"],
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };

        var tokenHandler = new JwtSecurityTokenHandler();
        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }

    public async Task<bool> RegisterUserAsync(string username, string password)
    {
        var existingUser = await userRepository.GetUserByUsernameAsync(username);
        if (existingUser != null)
        {
            return false; // User already exists
        }

        var passwordHash = BCrypt.Net.BCrypt.HashPassword(password);
        var newUser = new User
        {
            Username = username,
            PasswordHash = passwordHash
        };

        return await userRepository.CreateUserAsync(newUser);
    }

    public async Task<bool> ValidateUserAsync(string username, string password)
    {
        var user = await userRepository.GetUserByUsernameAsync(username);
        if (user == null)
        {
            return false;
        }

        return BCrypt.Net.BCrypt.Verify(password, user.PasswordHash);
    }
}
