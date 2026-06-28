namespace SpeakMate.Application.Interfaces
{
    public interface IAiService
    {
        Task<string> AnalyzeTextAsync(string text, CancellationToken cancellationToken);
    }
}
