using System.Text;
using BookingFlyWebApp.Models;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;

namespace BookingFlyWebApp.Service;

public class FlightService
{
    private readonly HttpClient _httpClient;
    private readonly string _urlApi;
    private readonly IHttpContextAccessor _httpContextAccessor;
    public FlightService(HttpClient httpClient, IOptions<ApiSettings> apiSettings,IHttpContextAccessor httpContextAccessor)
    {
        _httpClient = httpClient;
        _urlApi = apiSettings.Value.UrlApi;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task<TicketDto> CreateOrder(BookingData bookingData)
    {
        try
        {
            var requestUrl = $"{_urlApi}/api/v1/flight/add";
            var jsonContent = JsonConvert.SerializeObject(bookingData);
            var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync(requestUrl, content);
            if (response.IsSuccessStatusCode)
            {
                var jsonResponse = await response.Content.ReadAsStringAsync();
                Console.WriteLine(JsonConvert.DeserializeObject<FlightResponse>(jsonResponse));
                return JsonConvert.DeserializeObject<TicketDto>(jsonResponse);
            }
            return null;
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }

    public async Task<List<string>> ListSeatLocked(long flightId, string ticket_type)
    {
        try
        {
            var requestUrl = $"{_urlApi}/api/v1/assets/list_assets?flightId={flightId}&ticket_type={ticket_type}";
            var response = await _httpClient.GetAsync(requestUrl);
            if (response.IsSuccessStatusCode)
            {
                var responseData = await response.Content.ReadAsStringAsync();
                var seatList = JsonConvert.DeserializeObject<List<string>>(responseData);
                return seatList;
            }

            return null;
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }

    public async Task<string> InsertRedis(RedisRequest rd)
    {
        try
        {
            var assetsQuery = string.Join("&assets=", rd.assets);
            var requestUrl =
                $"{_urlApi}/api/v1/assets/add?flightId={rd.flightId}&ticket_type_go={rd.ticket_type_go}&assets={assetsQuery}";
            var response = await _httpClient.PostAsync(requestUrl, null);

            if (response.IsSuccessStatusCode)
            {
                var responseData = await response.Content.ReadAsStringAsync();
                Console.WriteLine("Response Data: " + responseData);

                if (responseData == "ok")
                {
                    return "ok";
                }

                Console.WriteLine("Unexpected response: " + responseData);
                return "fail";
            }

            Console.WriteLine($"Error: {response.StatusCode}, Content: {await response.Content.ReadAsStringAsync()}");
            return "fail";
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }


    public async Task<List<string>> ListSeat(int id, string typeSeat)
    {
        try
        {
            var requestUrl = $"{_urlApi}/api/v1/flight/get?flightId={id}&type_seats={typeSeat}";
            var response = await _httpClient.GetAsync(requestUrl);
            if (response.IsSuccessStatusCode)
            {
                var responseData = await response.Content.ReadAsStringAsync();
                var seatList = JsonConvert.DeserializeObject<List<string>>(responseData);
                return seatList;
            }

            return null;
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }

    public async Task<FlightResponse> SearchFlight(SearchFlight searchFlight, int number)
    {
        try
        {
            var requestUrl = $"{_urlApi}/api/v1/flight/list?number={number}";
            var jsonContent = JsonConvert.SerializeObject(searchFlight);
            var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");

            var response = await _httpClient.PostAsync(requestUrl, content);
            if (response.IsSuccessStatusCode)
            {
                var jsonResponse = await response.Content.ReadAsStringAsync();
                Console.WriteLine(JsonConvert.DeserializeObject<FlightResponse>(jsonResponse));
                return JsonConvert.DeserializeObject<FlightResponse>(jsonResponse);
            }

            return null;
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }
    
    
    
    public async Task MapSeatsToSession(HttpContext httpContext)
    {
        var selectedFlightJson = httpContext.Session.GetString("SelectedFlight");
        if (string.IsNullOrEmpty(selectedFlightJson))
            return;

        var selectedResults = JsonConvert.DeserializeObject<BidingModel>(selectedFlightJson);
        if (selectedResults == null) return;

        var seatMaps = await CreateSeatMaps(selectedResults);
        var seatMapJson = JsonConvert.SerializeObject(seatMaps);
        httpContext.Session.SetString("SeatMapList", seatMapJson);
    }
    
    
    public async Task<List<SeatMap>> GetListFlight()
    {
        var session = _httpContextAccessor.HttpContext?.Session;

        if (session == null)
        {
            return new List<SeatMap>(); 
        }

        var seatMap = session.GetString("SeatMapList"); 
        return string.IsNullOrEmpty(seatMap) 
            ? new List<SeatMap>() 
            : JsonConvert.DeserializeObject<List<SeatMap>>(seatMap);
    }

    public async Task<List<Customer>> GetListCustomer()
    {
        var session = _httpContextAccessor.HttpContext?.Session;

        if (session == null)
        {
            return null; 
        }
        var customers = session.GetString("Customers");
        return JsonConvert.DeserializeObject<List<Customer>>(customers);
    }

    public async Task LoadAvailableSeats(SeatMap selectedSeatMap, int flightId)
    {
        if (selectedSeatMap.economySeats > 0)
        {
            var seatLocked = await ListSeatLocked(flightId, "Economy");
            var bookedSeatsEconomy = await ListSeat(flightId, "Economy");
            for (var i = 0; i < selectedSeatMap.economySeats; i++)
            {
                var seatLetter = (char)('A' + i % 4);
                var row = i / 4 + 1;
                var seatNumber = seatLetter + row.ToString();
                var isBooked = bookedSeatsEconomy.Contains(seatNumber);
                var isLocked = seatLocked?.Contains(seatNumber) ?? false;
                ;
                selectedSeatMap.AvailableSeats.Add(new Seat
                {
                    Id = i + 1,
                    Number = seatNumber,
                    IsSelected = false,
                    IsBooked = isBooked,
                    IsLocked = isLocked
                });
            }
        }

        if (selectedSeatMap.businessSeats > 0)
        {
            var seatLocked = await ListSeatLocked(flightId, "Economy");
            var bookedSeatsBusiness = await ListSeat(flightId, "Business");
            for (var i = 0; i < selectedSeatMap.businessSeats; i++)
            {
                var seatLetter = "VIP"[i % 3];
                var row = i / 3 + 1;
                var seatNumber = seatLetter + row.ToString();
                var isBooked = bookedSeatsBusiness.Contains(seatNumber);
                var isLocked = seatLocked?.Contains(seatNumber) ?? false;
                ;
                selectedSeatMap.AvailableSeats.Add(new Seat
                {
                    Id = i + selectedSeatMap.economySeats + 1,
                    Number = seatNumber,
                    IsSelected = false,
                    IsBooked = isBooked,
                    IsLocked = isLocked
                });
            }
        }
    }

    public string GetCustomerNameBySeat(string seatNumber)
    {
        var session = _httpContextAccessor.HttpContext?.Session;
        var customersJson = session.GetString("Customers");
        var customers = JsonConvert.DeserializeObject<List<Customer>>(customersJson);

        // Tìm kiếm khách hàng đã đặt ghế này
        foreach (var customer in customers)
        {
            // Kiểm tra từng loại ghế đã đặt của khách hàng
            if (customer.seats_go != null && customer.seats_go.Values.Contains(seatNumber))
                return customer.fullName;

            if (customer.seats_go_child != null && customer.seats_go_child.Values.Contains(seatNumber))
                return customer.fullName;

            if (customer.seats_back != null && customer.seats_back.Values.Contains(seatNumber))
                return customer.fullName;

            if (customer.seats_back_child != null && customer.seats_back_child.Values.Contains(seatNumber))
                return customer.fullName;
        }

        return null;
    }

    public async Task<List<SeatMap>> CreateSeatMaps(BidingModel selectedResults)
    {
        var seatMaps = new List<SeatMap>();

        if (selectedResults.flightSelectGo != null)
        {
            var flightGo = selectedResults.flightSelectGo.flight_go;
            seatMaps.Add(CreateSeatMap(flightGo, selectedResults.flightSelectGo.seats_class, "seats_go"));

            if (flightGo.flights != null)
                foreach (var flight in flightGo.flights)
                    seatMaps.Add(CreateSeatMap(flight, selectedResults.flightSelectGo.seats_class, "seats_go_child"));
        }

        if (selectedResults.flightSelectBack != null)
        {
            var flightBack = selectedResults.flightSelectBack.flight_back;
            seatMaps.Add(CreateSeatMap(flightBack, selectedResults.flightSelectBack.seats_class, "seats_back"));

            if (flightBack.flights != null)
                foreach (var flight in flightBack.flights)
                    seatMaps.Add(
                        CreateSeatMap(flight, selectedResults.flightSelectBack.seats_class, "seats_back_child"));
        }

        return seatMaps;
    }

    public SeatMap CreateSeatMap(FlightDto flight, string seatsClass, string typeFlight)
    {
        return new SeatMap
        {
            id = flight.id,
            fromCity = flight.fromCity,
            toCity = flight.toCity,
            typeFlight = typeFlight,
            economySeats = seatsClass.Equals("economy") ? flight.economySeats : 0,
            businessSeats = seatsClass.Equals("business") ? flight.businessSeats : 0
        };
    }

}