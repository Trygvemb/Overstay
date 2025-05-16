using Overstay.Application.Commons.Constants;
using Overstay.Application.Commons.Errors;
using Overstay.Application.Commons.Results;
using Shouldly;
using Xunit;

namespace Overstay.UnitTest.Application.Commons;

public class ResultTests
{
    [Fact]
    public void Success_ShouldCreateSuccessfulResult()
    {
        // Act
        var result = Result.Success();

        // Assert
        result.IsSuccess.ShouldBeTrue();
        result.IsFailure.ShouldBeFalse();
        result.Error.ShouldBe(new Error(ErrorTypeConstants.None));
    }

    [Fact]
    public void Failure_ShouldCreateFailedResult()
    {
        // Arrange
        var error = new Error("TestError", "This is a test error.");

        // Act
        var result = Result.Failure(error);

        // Assert
        result.IsSuccess.ShouldBeFalse();
        result.IsFailure.ShouldBeTrue();
        result.Error.ShouldBe(error);
    }

    [Fact]
    public void Success_WithValue_ShouldCreateSuccessfulResultWithValue()
    {
        // Arrange
        var value = 42;

        // Act
        var result = Result.Success(value);

        // Assert
        result.IsSuccess.ShouldBeTrue();
        result.Value.ShouldBe(value);
    }

    [Fact]
    public void Failure_WithValue_ShouldCreateFailedResultWithError()
    {
        // Arrange
        var error = new Error("TestError", "This is a test error.");

        // Act
        var result = Result.Failure<int>(error);

        // Assert
        result.IsSuccess.ShouldBeFalse();
        result.Error.ShouldBe(error);
        Should.Throw<InvalidOperationException>(() => result.Value);
    }

    [Fact]
    public void Map_ShouldTransformValueOnSuccess()
    {
        // Arrange
        var result = Result.Success(2);

        // Act
        var mappedResult = result.Map(x => x * 2);

        // Assert
        mappedResult.IsSuccess.ShouldBeTrue();
        mappedResult.Value.ShouldBe(4);
    }

    [Fact]
    public void Map_ShouldPreserveErrorOnFailure()
    {
        // Arrange
        var error = new Error("TestError", "This is a test error.");
        var result = Result.Failure<int>(error);

        // Act
        var mappedResult = result.Map(x => x * 2);

        // Assert
        mappedResult.IsSuccess.ShouldBeFalse();
        mappedResult.Error.ShouldBe(error);
    }
}
