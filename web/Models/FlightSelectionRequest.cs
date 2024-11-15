namespace BookingFlyWebApp.Models
{
    public class FlightSelectionRequest
    {
        public int flightId { get; set; }
        //public int? returnFlightId { get; set; }
        public int number { get; set; }
        public string seatsClass { get; set; }
        public int adultQuantyti { set; get; }
        public int childtQuantyti { set; get; }
        public decimal totalPrice  { set; get; }

    }
}
