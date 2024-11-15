using Backend.Data.model;
using Backend.Service.View;

namespace Backend.Service.ViewModel;

public class FlightSegmentViewModel : flight_segment
{
    public void BeforeSave(FlightSegmentViewModel model)
    {
        if (model == null)
        {
            throw new Exception();
        }
    }

    public void SetValue(decimal price, int distance, int e_seats, int b_seats, string air_code, string from , string to)
    {
        base_price = price * distance ;
        r_eseats = e_seats;
        r_bseats = b_seats;
        fromCity = from;
        toCity = to;
        code = GenerateRandomCode(air_code);
    }
    
    private string GenerateRandomCode(string air_code)
    {
        DateTime currentDate = DateTime.Now;
        string datePart = currentDate.ToString("ddMM"); 
        string randomPart = new Random().Next(1000, 9999).ToString();
        return $"{air_code}{datePart}{randomPart}";
    }
}



public class FlightSegmentRequest : DefaultPagingRequest
{
    public string key { set; get; }
      
}

public class FlightSegmentResponse
{
    public List<FlightSegmentViewModel> Items { get; set; } = [];
    public int total { get; set; }
}

public class FlightSegmentPagingResponse
{
    public FlightSegmentResponse PagingResponse { get; set; }
    public FlightSegmentRequest PagingModel { get; set; }

    public void Binding(FlightSegmentResponse pagingResponse)
    {
        PagingResponse = pagingResponse;
        PagingModel.total = pagingResponse.total;
    }
}

//Trip
public class FlightTripRequest : DefaultPagingRequest
{
    public string key { set; get; }
      
}
public class FlightTripResponse
{
    public List<FlightTripViewModel> Items { get; set; } = [];
    public int total { get; set; }
}

public class FlightTripPagingResponse
{
    public FlightTripResponse PagingResponse { get; set; }
    public FlightTripRequest PagingModel { get; set; }

    public void Binding(FlightTripResponse pagingResponse)
    {
        PagingResponse = pagingResponse;
        PagingModel.total = pagingResponse.total;
    }
}