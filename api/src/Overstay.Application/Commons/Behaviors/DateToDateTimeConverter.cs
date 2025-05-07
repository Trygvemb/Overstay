using System.Globalization;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace Overstay.Application.Commons.Behaviors;

public class DateToDateTimeConverter : JsonConverter<DateTime>
{
    private readonly string[] _formats = ["yyyy-MM-dd", "MM/dd/yyyy", "dd-MM-yyyy"];

    public override DateTime Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        var dateString = reader.GetString();
        if (DateTime.TryParseExact(dateString, _formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out var date))
        {
            return date;
        }
        throw new JsonException($"Invalid date format. Supported formats: {string.Join(", ", _formats)}");
    }

    public override void Write(Utf8JsonWriter writer, DateTime value, JsonSerializerOptions options)
    {
        writer.WriteStringValue(value.ToString("yyyy-MM-dd"));
    }
}