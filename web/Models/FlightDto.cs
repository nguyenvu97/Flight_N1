namespace BookingFlyWebApp.Models;

public class FlightDto
{
    public string toCity;
    public int id { set; get; }

    public string fromCity { set; get; }

    public DateTime departureTime { set; get; }
    public DateTime arrivalTime { set; get; }

    public decimal basePrice { set; get; }

    public int reservedSeats { set; get; }

    public int reservedBusinessSeats { set; get; }

    public int economySeats { set; get; }

    public int businessSeats { set; get; }

    public int totalSeats { set; get; }

    public string airline { set; get; }

    public List<FlightDto> flights { set; get; }
}

public class FlightResponse
{
    public List<FlightDto> flight_go { get; set; } = new();
    public List<FlightDto> flight_back { get; set; } = new();
    public int adultQuantity { set; get; }
    public int childQuantity { set; get; }
}

public class FlightSelectGo
{
    public int adultQuantyti { set; get; }
    public int childtQuantyti { set; get; }
    public string seats_class { get; set; }
    public FlightDto flight_go { get; set; }
    public decimal totalPrice { set; get; }
    public string FlightIds { get; set; }
}

public class FlightSelectBack
{
    public int adultQuantyti { set; get; }
    public int childtQuantyti { set; get; }
    public string seats_class { get; set; }
    public FlightDto flight_back { get; set; }
    public decimal totalPrice { set; get; }
    public string FlightIds { get; set; }
}

public class BidingModel
{
    public FlightSelectGo flightSelectGo { set; get; }
    public FlightSelectBack flightSelectBack { set; get; }
}