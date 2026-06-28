namespace SpeakMate.Application.Interfaces
{
    public interface ISpeechProcessingService
    {
        Task<string> ProcessSpeechAsync(string text, CancellationToken cancellationToken);
    }
}
