using Microsoft.IdentityModel.Tokens;
using Microsoft.Extensions.Configuration;
using SpeakMate.Application.Interfaces;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace SpeakMate.Infrastructure.Auth
{
    public class JwtAuthService : IAuthService
    {
        private readonly IConfiguration _configuration;

		public JwtAuthService(IConfiguration configuration) => _configuration = configuration;

		public string GenerateJwtToken(string username)
        {
            var jwtSettings = _configuration.GetSection("Jwt");
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

        public Task<bool> RegisterUserAsync(string username, string password)
        {
            // Mock registration: always return true for now
            return Task.FromResult(true);
        }

        public Task<bool> ValidateUserAsync(string username, string password)
        {
            // Mock validation: allow any user for now
            return Task.FromResult(!string.IsNullOrEmpty(username) && !string.IsNullOrEmpty(password));
        }
    }
}
