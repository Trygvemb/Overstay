using Overstay.Application.Commons.Results;

namespace Overstay.Application.Commons.Errors;

public sealed record Error(string Code, string? Message = null)
{
    //public static implicit operator Result(Error error) => Result.Failure(error);

    internal static Error None => new(ErrorTypeConstants.None);
}
