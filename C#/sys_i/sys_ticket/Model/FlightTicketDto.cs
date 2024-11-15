#nullable disable

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace SysAdmin.Models;

public class FlightTicketDto
{
    public int id {set;get;}

    public string fromCity{set;get;}

    public string toCity{set;get;}
    
    [JsonConverter(typeof(DepartureTimeConverter))]

    public DateTime  departureTime{set;get;}
    
    [JsonConverter(typeof(DepartureTimeConverter))]

    public DateTime  arrivalTime{set;get;}

    public decimal basePrice{set;get;}

    public string airline{set;get;}

    public List<FlightTicketDto> flights = new List<FlightTicketDto>();
}

public class DepartureTimeConverter : JsonConverter
{
    public override bool CanConvert(Type objectType)
    {
        return objectType == typeof(DateTime);
    }

    public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
    {
        writer.WriteValue(((DateTime)value).ToString("yyyy-MM-dd HH:mm:ss"));
    }

    public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
    {
        if (reader.TokenType == JsonToken.StartArray)
        {
            JArray array = JArray.Load(reader);
            return array.FirstOrDefault()?.ToObject<DateTime>();
        }
        else if (reader.TokenType == JsonToken.Date || reader.TokenType == JsonToken.String)
        {
            return reader.Value != null ? (DateTime)reader.Value : default(DateTime);
        }
        
        throw new JsonReaderException("Unexpected token type: " + reader.TokenType);
    }
}
