namespace BookingFlyWebApp.Models;

public class SearchFlight
{
    public string startDate { set; get; }
    public string endDate { set; get; }
    public string departure { set; get; }
    public string arrival { set; get; }
    public int adultQuantity{ set; get; }
    public int childQuantity{ set; get; }
}