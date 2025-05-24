using System.Globalization;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace Overstay.Application.Commons.Behaviors;

public class NullableDateTimeBehavior : JsonConverter<DateTime?>
{
    private readonly string[] _formats =
    [
        "yyyy-MM-dd",
        "MM/dd/yyyy",
        "dd-MM-yyyy",
        "yyyy-MM-ddTHH:mm:ssZ",
        "o", // ISO 8601 format
    ];

    public override DateTime? Read(
        ref Utf8JsonReader reader,
        Type typeToConvert,
        JsonSerializerOptions options
    )
    {
        if (reader.TokenType == JsonTokenType.Null)
        {
            return null;
        }

        var dateString = reader.GetString();

        if (string.IsNullOrWhiteSpace(dateString))
        {
            return null;
        }

        if (
            DateTime.TryParseExact(
                dateString,
                _formats,
                CultureInfo.InvariantCulture,
                DateTimeStyles.AssumeUniversal | DateTimeStyles.AdjustToUniversal,
                out var date
            )
        )
        {
            return date;
        }

        // Return null for invalid formats instead of throwing
        // This allows FluentValidation to handle the validation
        return null;
    }

    public override void Write(
        Utf8JsonWriter writer,
        DateTime? value,
        JsonSerializerOptions options
    )
    {
        if (value.HasValue)
        {
            writer.WriteStringValue(value.Value.ToString("o"));
        }
        else
        {
            writer.WriteNullValue();
        }
    }
}

// Keep the original converter for non-nullable DateTime if needed
public class DateTimeBehavior : JsonConverter<DateTime>
{
    private readonly string[] _formats =
    [
        "yyyy-MM-dd",
        "MM/dd/yyyy",
        "dd-MM-yyyy",
        "yyyy-MM-ddTHH:mm:ssZ",
        "o",
    ];

    public override DateTime Read(
        ref Utf8JsonReader reader,
        Type typeToConvert,
        JsonSerializerOptions options
    )
    {
        var dateString = reader.GetString();

        if (
            DateTime.TryParseExact(
                dateString,
                _formats,
                CultureInfo.InvariantCulture,
                DateTimeStyles.AssumeUniversal | DateTimeStyles.AdjustToUniversal,
                out var date
            )
        )
        {
            return date;
        }

        // Return DateTime.MinValue for invalid formats instead of throwing
        // This allows FluentValidation to handle the validation
        return DateTime.MinValue;
    }

    public override void Write(Utf8JsonWriter writer, DateTime value, JsonSerializerOptions options)
    {
        writer.WriteStringValue(value.ToString("o"));
    }
}
