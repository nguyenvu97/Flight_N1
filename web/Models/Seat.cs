namespace BookingFlyWebApp.Models;

public class Seat
{
    public int Id { get; set; }
    public string Number { get; set; }
    public bool IsSelected { get; set; }
    public bool IsBooked { get; set; }
    public bool IsLocked { get; set; }
    public string cusname { get; set; }
}