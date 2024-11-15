namespace BookingFlyWebApp.Models;

public class SeatSelectionRequest
{
    public string SeatNumber { get; set; }
    public int FlightId { get; set; }
    public string CustomerName { get; set; }
}