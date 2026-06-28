using Grpc.Core;
using SpeakMate.Application.Interfaces;
using SpeakMate.Contracts;

namespace SpeakMate.Server.Services
{
    public class AuthGrpcService : AuthService.AuthServiceBase
    {
        private readonly IAuthService _authLogic;

		public AuthGrpcService(IAuthService authLogic) => _authLogic = authLogic;

		public override async Task<AuthResponse> Login(LoginRequest request, ServerCallContext context)
        {
            bool isValid = await _authLogic.ValidateUserAsync(request.Username, request.Password);
            if (isValid)
            {
                string token = _authLogic.GenerateJwtToken(request.Username);
                return new AuthResponse { Success = true, Token = token, Message = "Login successful" };
            }
            return new AuthResponse { Success = false, Message = "Invalid credentials" };
        }

        public override async Task<AuthResponse> Register(RegisterRequest request, ServerCallContext context)
        {
            bool success = await _authLogic.RegisterUserAsync(request.Username, request.Password);
            if (success)
            {
                string token = _authLogic.GenerateJwtToken(request.Username);
                return new AuthResponse { Success = true, Token = token, Message = "Registration successful" };
            }
            return new AuthResponse { Success = false, Message = "Registration failed" };
        }
    }
}
