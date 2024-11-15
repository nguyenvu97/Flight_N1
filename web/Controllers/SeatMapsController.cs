using BookingFlyWebApp.Common;
using BookingFlyWebApp.Models;
using BookingFlyWebApp.Service;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace BookingFlyWebApp.Controllers;

public class SeatMapsController : Controller
{
    private readonly FlightService _flightService;

    public SeatMapsController(FlightService flightService)
    {
        _flightService = flightService;
    }

    public async Task<IActionResult> SeatMap(int id)
    {
        await Load();
        // await _flightService.MapSeatsToSession(HttpContext);
        var flights = await _flightService.GetListFlight();
        var flight = id > 0 ? flights.FirstOrDefault(f => f.id == id) : flights.FirstOrDefault();
        string cus = null;
        var customers = await _flightService.GetListCustomer();
        
        var custom = string.IsNullOrEmpty(cus)
            ? customers.FirstOrDefault()
            : customers.FirstOrDefault(c => c.fullName == cus);
        ViewBag.C = custom;

        if (flight == null) return NotFound("Chuyến bay không tồn tại.");

        var currentIndex = flights.IndexOf(flight);
        id = flight.id;
        ViewBag.NexFlight = flight.id;
        ViewBag.IsLast = currentIndex == flights.Count - 1;
        ViewBag.IsFirst = currentIndex == 0;
        if (flight != null)
        {
            ViewBag.IsLast = currentIndex == flights.Count - 1;
            ViewBag.IsFirst = currentIndex == 0;
        }
        

        return View(id);
    }


    public async Task<IActionResult> NextFlight(int currentFlightId)
    {
        await Load();
        var flights = await _flightService.GetListFlight();
        var flight = flights.FirstOrDefault(f => f.id == currentFlightId);

        if (flight == null) return NotFound("Chuyến bay không tồn tại.");

        var currentIndex = flights.IndexOf(flight);
        if (currentIndex >= flights.Count - 1) return NotFound("Không có chuyến bay tiếp theo.");

        var nextFlight = flights[currentIndex + 1];
        return RedirectToAction("SeatMap", new { nextFlight.id });
    }

    public async Task<IActionResult> PreFlight(int currentFlightId)
    {
        await Load();
        var flights = await _flightService.GetListFlight();
        var flight = flights.FirstOrDefault(f => f.id == currentFlightId);

        if (flight == null) return NotFound("Chuyến bay không tồn tại.");

        var currentIndex = flights.IndexOf(flight);

        if (currentIndex <= 0) return NotFound("Không có chuyến bay trước.");

        var previousFlight = flights[currentIndex - 1];
        return RedirectToAction("SeatMap", new { previousFlight.id });
    }

    public async Task<IActionResult> SeatMapPartial(int id, string? cus)
    {
        var flights = await _flightService.GetListFlight();
        var flight = flights.FirstOrDefault(f => f.id == id);
        var customers = await _flightService.GetListCustomer();
        var custom = string.IsNullOrEmpty(cus)
            ? customers.FirstOrDefault()
            : customers.FirstOrDefault(c => c.fullName == cus);
        if (custom != null)
            ViewBag.Custom = custom.fullName;
        else
            ViewBag.Custom = "Khách hàng không tìm thấy";
        if (flight == null) return NotFound("Chuyến bay không tồn tại.");

        ViewBag.NexFlight = flight?.id;


        var seatMapListJson = HttpContext.Session.GetString("SeatMapList");
        var seatMaps = JsonConvert.DeserializeObject<List<SeatMap>>(seatMapListJson);
        var selectedSeatMap = seatMaps?.FirstOrDefault(sm => sm.id == id);

        if (selectedSeatMap == null) return NotFound("Không tìm thấy thông tin SeatMap.");

        selectedSeatMap.AvailableSeats = new List<Seat>();
        await _flightService.LoadAvailableSeats(selectedSeatMap, id);
        // await LoadSelectedSeats(flight.id);
        var selectedSeats = new List<string>();
        foreach (var customer in customers)
        {
            if (customer.seats_go.ContainsKey(flight.id))
                selectedSeats.Add(customer.seats_go[flight.id]);
            if (customer.seats_go_child.ContainsKey(flight.id))
                selectedSeats.Add(customer.seats_go_child[flight.id]);
            if (customer.seats_back.ContainsKey(flight.id))
                selectedSeats.Add(customer.seats_back[flight.id]);
            if (customer.seats_back_child.ContainsKey(flight.id))
                selectedSeats.Add(customer.seats_back_child[flight.id]);
        }
        
        foreach (var seat in selectedSeatMap.AvailableSeats)
        foreach (var customer in customers)
        {
            if (customer.seats_go.ContainsKey(flight.id) && customer.seats_go[flight.id] == seat.Number)
            {
                seat.IsSelected = true;
                seat.cusname = customer.fullName;
            }


            if (customer.seats_go_child.ContainsKey(flight.id) && customer.seats_go_child[flight.id] == seat.Number)
            {
                seat.IsSelected = true;
                seat.cusname = customer.fullName;
            }


            if (customer.seats_back.ContainsKey(flight.id) && customer.seats_back[flight.id] == seat.Number)
            {
                seat.IsSelected = true;
                seat.cusname = customer.fullName;
            }


            if (customer.seats_back_child.ContainsKey(flight.id) && customer.seats_back_child[flight.id] == seat.Number)
            {
                seat.IsSelected = true;
                seat.cusname = customer.fullName;
            }
        }


        return PartialView(selectedSeatMap);
    }

    public async Task<IActionResult> SeatMapFlight(List<int> flightId)
    {
        await Load();
        return View(flightId);
    }

    public async Task<IActionResult> ListCustomer()
    {
        await Load();
        return PartialView();
    }
    

    public async Task<IActionResult> DoSelectSeat([FromBody] SeatSelectionRequest request)
    {
        var flights = await _flightService.GetListFlight();
        var flight = flights.FirstOrDefault(f => f.id == request.FlightId);

        if (flight == null) return NotFound("Chuyến bay không tồn tại.");

        var customers = await _flightService.GetListCustomer();
        var customer = customers.FirstOrDefault(c => c.fullName == request.CustomerName);

        if (customer == null) return NotFound("Khách hàng không tồn tại.");

        if (flight.typeFlight == "seats_go" && customer.seats_go == null)
            customer.seats_go = new Dictionary<int, string>();
        else if (flight.typeFlight == "seats_go_child" && customer.seats_go_child == null)
            customer.seats_go_child = new Dictionary<int, string>();
        else if (flight.typeFlight == "seats_back" && customer.seats_back == null)
            customer.seats_back = new Dictionary<int, string>();
        else if (flight.typeFlight == "seats_back_child" && customer.seats_back_child == null)
            customer.seats_back_child = new Dictionary<int, string>();

        switch (flight.typeFlight)
        {
            case "seats_go":
                customer.seats_go[flight.id] = request.SeatNumber;
                break;
            case "seats_go_child":
                customer.seats_go_child[flight.id] = request.SeatNumber;
                break;
            case "seats_back":
                customer.seats_back[flight.id] = request.SeatNumber;
                break;
            case "seats_back_child":
                customer.seats_back_child[flight.id] = request.SeatNumber;
                break;
            default:
                return BadRequest("Loại chuyến bay không hợp lệ.");
        }

        // rd = new RedisRequest
        // {
        //     flightId = request.FlightId,
        //     ticket_type_go = Gettype(flight),
        //     assets = new HashSet<string>()
        // };
        //
        // rd.assets.Add(request.SeatNumber);
        //
        // await _flightService.InsertRedis(rd);

        HttpContext.Session.SetString("Customers", JsonConvert.SerializeObject(customers));
        return Ok(new { flight.id, name = customer.fullName });
    }


    private string Gettype(SeatMap seatMap)
    {
        if (seatMap.economySeats > 0) return "Economy";

        if (seatMap.businessSeats > 0) return "Business";

        return null;
    }

    // public async Task MapSeatsToSession()
    // {
    //     var selectedFlightJson = HttpContext.Session.GetString("SelectedFlight");
    //     if (string.IsNullOrEmpty(selectedFlightJson))
    //         return;
    //
    //     var selectedResults = JsonConvert.DeserializeObject<BidingModel>(selectedFlightJson);
    //     if (selectedResults == null) return;
    //
    //     var seatMaps = await _flightService.CreateSeatMaps(selectedResults);
    //     var seatMapJson = JsonConvert.SerializeObject(seatMaps);
    //     HttpContext.Session.SetString("SeatMapList", seatMapJson);
    // }

    private async Task Load()
    {
        var searchFlightSession = HttpContext.Session.GetString("SearchFlight");
        if (!string.IsNullOrEmpty(searchFlightSession))
            ViewBag.SearchFlight = JsonConvert.DeserializeObject<SearchFlight>(searchFlightSession);

        ViewBag.SearchNumber = HttpContext.Session.GetInt32("SearchNumber") ?? 0;
        var selectedFlight = HttpContext.Session.GetString("SelectedFlight");
        ViewBag.SelectedResults = JsonConvert.DeserializeObject<BidingModel>(selectedFlight);

        var flightBookingData = HttpContext.Session.GetString("Customers");
        ViewBag.BookingData = JsonConvert.DeserializeObject<List<Customer>>(flightBookingData);
    }

    public async Task<IActionResult> SaveBookingData()
    {
        var selectedResultsJson = HttpContext.Session.GetString("SelectedFlight");
        var customerListJson = HttpContext.Session.GetString("Customers");

        if (selectedResultsJson == null || customerListJson == null)
            return BadRequest("Fail");


        // await _flightService.InsertRedis(rd);

        var selectedResults = JObject.Parse(selectedResultsJson);
        var customerList = JsonConvert.DeserializeObject<List<Customer>>(customerListJson);

        var bookingData = MapBoking.BookingDataMapper.MapToBookingData(selectedResults, customerList);
        HttpContext.Session.SetString("Booking", JsonConvert.SerializeObject(bookingData));

     


        var isSelect = true;
        HttpContext.Session.SetString("IsComfirmSeat", isSelect.ToString());
        return Json(bookingData);
    }



    public class SeatSelectionRequest
    {
        public string SeatNumber { get; set; }
        public int FlightId { get; set; }
        public string CustomerName { get; set; }
    }
}