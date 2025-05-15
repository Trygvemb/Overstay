// using System.IdentityModel.Tokens.Jwt;
// using Microsoft.Extensions.Configuration;
// using Microsoft.Extensions.Logging;
// using Moq;
// using Overstay.Application.Features.Users.Responses;
// using Overstay.Infrastructure.Services;
// using Shouldly;
//
// namespace Overstay.UnitTest.Infrastructure.Services;
//
// public class TokenServiceTests
// {
//     private readonly Mock<IConfiguration> _configurationMock;
//     private readonly Mock<ILogger<TokenService>> _loggerMock;
//     private readonly TokenService _tokenService;
//
//     public TokenServiceTests()
//     {
//         _configurationMock = new Mock<IConfiguration>();
//         _loggerMock = new Mock<ILogger<TokenService>>();
//
//         // Mock configuration values
//         _configurationMock
//             .Setup(c => c["JwtSettings:SecretKey"])
//             .Returns("SuperSecretKey12345678901234567890");
//         _configurationMock.Setup(c => c["JwtSettings:Issuer"]).Returns("TestIssuer");
//         _configurationMock.Setup(c => c["JwtSettings:Audience"]).Returns("TestAudience");
//         _configurationMock.Setup(c => c["JwtSettings:ExpirationMinutes"]).Returns("30");
//
//         _tokenService = new TokenService(_configurationMock.Object, _loggerMock.Object);
//     }
//
//     [Fact]
//     public async Task GenerateJwtToken_ShouldReturnValidTokenResponse()
//     {
//         // Arrange
//         var user = new UserWithRolesResponse
//         {
//             Id = Guid.NewGuid(),
//             UserName = "TestUser",
//             Email = "testuser@example.com",
//             Roles = new List<string> { "Admin", "User" },
//         };
//
//         // Act
//         var tokenResponse = await _tokenService.GenerateJwtToken(user);
//
//         // Assert
//         tokenResponse.ShouldNotBeNull();
//         tokenResponse.AccessToken.ShouldNotBeNullOrEmpty();
//         tokenResponse.UserId.ShouldBe(user.Id);
//         tokenResponse.ExpiresAt.ShouldBeGreaterThan(DateTime.Now);
//
//         // Validate token structure
//         var handler = new JwtSecurityTokenHandler();
//         var token = handler.ReadJwtToken(tokenResponse.AccessToken);
//         token.ShouldNotBeNull();
//         token.Claims.ShouldContain(c => c.Type == "nameid" && c.Value == user.Id.ToString());
//         token.Claims.ShouldContain(c => c.Type == "unique_name" && c.Value == user.UserName);
//         token.Claims.ShouldContain(c => c.Type == "email" && c.Value == user.Email);
//         token.Claims.ShouldContain(c => c.Type == "role" && c.Value == "Admin");
//     }
// }
