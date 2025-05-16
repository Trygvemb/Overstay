using Overstay.Application.Commons.Errors;
using Overstay.Application.Commons.Results;
using Shouldly;

namespace Overstay.UnitTest.Application.Commons;

public class ResultExtensionsTests
{
    [Fact]
    public void GetValue_ShouldReturnValueForSuccessfulResult()
    {
        // Arrange
        var result = Result.Success(42);

        // Act
        var value = result.GetValue<int>();

        // Assert
        value.ShouldBe(42);
    }

    [Fact]
    public void GetValue_ShouldThrowForFailedResult()
    {
        // Arrange
        var result = Result.Failure<int>(new Error("TestError", "This is a test error."));

        // Act & Assert
        Should.Throw<InvalidOperationException>(() => result.GetValue<int>());
    }

    [Fact]
    public void ValueOrDefault_ShouldReturnValueForSuccessfulResult()
    {
        // Arrange
        var result = Result.Success(42);

        // Act
        var value = result.ValueOrDefault(0);

        // Assert
        value.ShouldBe(42);
    }

    [Fact]
    public void ValueOrDefault_ShouldReturnDefaultForFailedResult()
    {
        // Arrange
        var result = Result.Failure<int>(new Error("TestError", "This is a test error."));

        // Act
        var value = result.ValueOrDefault(0);

        // Assert
        value.ShouldBe(0);
    }

    [Fact]
    public void TryGetValue_ShouldReturnTrueAndValueForSuccessfulResult()
    {
        // Arrange
        var result = Result.Success(42);

        // Act
        var success = result.TryGetValue<int>(out var value);

        // Assert
        success.ShouldBeTrue();
        value.ShouldBe(42);
    }

    [Fact]
    public void TryGetValue_ShouldReturnFalseForFailedResult()
    {
        // Arrange
        var result = Result.Failure<int>(new Error("TestError", "This is a test error."));

        // Act
        var success = result.TryGetValue<int>(out var value);

        // Assert
        success.ShouldBeFalse();
        value.ShouldBe(0);
    }
}
