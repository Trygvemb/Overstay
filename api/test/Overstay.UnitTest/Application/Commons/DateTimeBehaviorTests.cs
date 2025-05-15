using System.Text.Json;
using Overstay.Application.Commons.Behaviors;
using Shouldly;

namespace Overstay.UnitTest.Application.Commons;

public class DateTimeBehaviorTests
{
    private readonly JsonSerializerOptions _options = new()
    {
        Converters = { new DateTimeBehavior() },
    };

    [Theory]
    [InlineData("2023-10-01", "2023-10-01T00:00:00.0000000Z")]
    [InlineData("10/01/2023", "2023-10-01T00:00:00.0000000Z")]
    [InlineData("01-10-2023", "2023-10-01T00:00:00.0000000Z")]
    [InlineData("2023-10-01T12:30:45Z", "2023-10-01T12:30:45.0000000Z")]
    public void Read_ShouldParseValidDateStrings(string input, string expectedIso)
    {
        // Act
        var result = JsonSerializer.Deserialize<DateTime>($"\"{input}\"", _options);

        // Assert
        result.ToString("o").ShouldBe(expectedIso);
    }

    [Fact]
    public void Read_ShouldThrowForInvalidDateString()
    {
        // Arrange
        var invalidDate = "\"invalid-date\"";

        // Act & Assert
        Should.Throw<JsonException>(() =>
            JsonSerializer.Deserialize<DateTime>(invalidDate, _options)
        );
    }

    [Fact]
    public void Write_ShouldSerializeToIso8601Format()
    {
        // Arrange
        var date = new DateTime(2023, 10, 1, 12, 30, 45, DateTimeKind.Utc);

        // Act
        var result = JsonSerializer.Serialize(date, _options);

        // Assert
        result.ShouldBe("\"2023-10-01T12:30:45.0000000Z\"");
    }
}
