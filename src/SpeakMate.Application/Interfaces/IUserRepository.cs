using SpeakMate.Domain.Entities;

namespace SpeakMate.Application.Interfaces;

public interface IUserRepository
{
    Task<User?> GetUserByUsernameAsync(string username);
    Task<bool> CreateUserAsync(User user);
}
