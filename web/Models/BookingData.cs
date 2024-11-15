namespace BookingFlyWebApp.Models;

public class BookingData
{
    public List<int> flight_go { get; set; } = new();
    public List<int> flight_back { get; set; } = new();
    public List<Customer> customers { get; set; }
    public bool? ticketTypeGo { get; set; }
    public bool? ticketTypeBack { get; set; }
}