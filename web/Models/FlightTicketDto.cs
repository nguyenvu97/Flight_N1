namespace BookingFlyWebApp.Models;

public class FlightTicketDto
{
    public int id {set;get;}

    public string fromCity{set;get;}

    public string toCity{set;get;}

    public DateTime departureTime{set;get;} = DateTime.Now;

    public DateTime arrivalTime{set;get;}= DateTime.Now;

    public decimal basePrice{set;get;}

    public string airline{set;get;}

    public List<FlightTicketDto> flights = new List<FlightTicketDto>();
}