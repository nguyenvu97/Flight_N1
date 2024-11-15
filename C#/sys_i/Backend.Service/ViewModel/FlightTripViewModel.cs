using Backend.Data.model;

namespace Backend.Service.ViewModel;

public class FlightTripViewModel
{
    public int TripId { get; set; }
    public string FromCity { get; set; }
    public string ToCity { get; set; }
    public DateTime DepartureTime { get; set; }
    public DateTime ArrivalTime { get; set; }
    public decimal TotalPrice { get; set; }
    public string Segment { get; set; }
    public List<FlightSegmentViewModel> Segments { get; set; } = new List<FlightSegmentViewModel>();
}
