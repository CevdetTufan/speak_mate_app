namespace SpeakMate.Application.Interfaces
{
    public interface IAuthService
    {
        string GenerateJwtToken(string username);
        Task<bool> ValidateUserAsync(string username, string password);
        Task<bool> RegisterUserAsync(string username, string password);
    }
}
