namespace BookingFlyWebApp.Models;

public class SelectSeatCustomer
{
    public string Name { get; set; }
    public string typeFlight { get; set; }
    public Dictionary<int, string> SelectedSeats { get; set; } = new();
}