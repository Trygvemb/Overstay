using System.Globalization;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace Overstay.Application.Commons.Behaviors;

public class DateTimeBehavior : JsonConverter<DateTime>
{
    private readonly string[] _formats =
    [
        "yyyy-MM-dd",
        "MM/dd/yyyy",
        "dd-MM-yyyy",
        "o", // ISO 8601 format
        "yyyy-MM-ddTHH:mm:ssZ", // Added format for datetime picker
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
        throw new JsonException(
            $"Invalid date format. Supported formats: {string.Join(", ", _formats)}"
        );
    }

    public override void Write(Utf8JsonWriter writer, DateTime value, JsonSerializerOptions options)
    {
        writer.WriteStringValue(value.ToString("o")); // Use ISO 8601 format for output
    }
}
