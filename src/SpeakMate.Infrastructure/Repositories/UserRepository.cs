using Microsoft.EntityFrameworkCore;
using SpeakMate.Application.Interfaces;
using SpeakMate.Domain.Entities;
using SpeakMate.Infrastructure.Data;

namespace SpeakMate.Infrastructure.Repositories;

public class UserRepository(SpeakMateDbContext context) : IUserRepository
{
    public async Task<bool> CreateUserAsync(User user)
    {
        await context.Users.AddAsync(user);
        var result = await context.SaveChangesAsync();
        return result > 0;
    }

    public async Task<User?> GetUserByUsernameAsync(string username)
    {
        return await context.Users.FirstOrDefaultAsync(u => u.Username == username);
    }
}
