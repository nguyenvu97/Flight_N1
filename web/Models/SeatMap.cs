namespace BookingFlyWebApp.Models;

public class SeatMap
{
    public int id { set; get; }
    public string toCity { set; get; }
    public string typeFlight { set; get; }
    public string fromCity { set; get; }
    public int economySeats { set; get; }
    public int businessSeats { set; get; }
    public List<Seat> AvailableSeats { get; set; } = new List<Seat>();
}