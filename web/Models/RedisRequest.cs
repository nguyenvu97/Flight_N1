namespace BookingFlyWebApp.Models;

public class RedisRequest
{
    public long flightId { get; set; }
    public string ticket_type_go { get; set; }
    public HashSet<string> assets { get; set; } = new();
}