namespace Overstay.Application.Responses;

public class TokenResponse
{
    public string AccessToken { get; set; } = string.Empty;
    public Guid? UserId { get; set; }
    public DateTime ExpiresAt { get; set; }
}
