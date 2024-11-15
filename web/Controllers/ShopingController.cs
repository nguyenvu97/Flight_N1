using BookingFlyWebApp.Common;
using BookingFlyWebApp.Models;
using BookingFlyWebApp.Service;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace BookingFlyWebApp.Controllers;

public class ShopingController(FlightService _flightService, ShopingService _shopingService) : Controller
{
    public async Task<IActionResult> ShopingCart()
    {
        await Load();
        return View();
    }

    public async Task<IActionResult> ShopingGo()
    {
        await Load();
        return PartialView();
    }

    public async Task<IActionResult> ShopingBack()
    {
        await Load();
        return PartialView();
    }

    public async Task<IActionResult> ShopingCustiomer()
    {
        // await Load();
        return PartialView();
    }

    public async Task<IActionResult> ShopingDetail()
    {
        await Load();
        return PartialView();
    }

    public async Task<IActionResult> ShopingBagge()
    {
        await Load();
        return PartialView();
    }

    public async Task<IActionResult> ConfirmTickket()
    {
        var bookingDataJson = HttpContext.Session.GetString("Booking");
        var bookingdt = string.IsNullOrEmpty(bookingDataJson)
            ? new BookingData()
            : JsonConvert.DeserializeObject<BookingData>(bookingDataJson);

        await _shopingService.AutoAssignSeatsForCustomers(bookingdt);

        var requests = new List<RedisRequest>();

        foreach (var flightId in bookingdt.flight_go)
        {
            var rd = new RedisRequest
            {
                flightId = flightId,
                ticket_type_go = bookingdt.ticketTypeGo.HasValue && bookingdt.ticketTypeGo.Value
                    ? "Economy"
                    : "Business",
                assets = new HashSet<string>()
            };

            var lockedSeats = await _flightService.ListSeatLocked(flightId, rd.ticket_type_go);
            
            foreach (var customer in bookingdt.customers)
            {
                // if (customer.seats_go.ContainsKey(flightId)) rd.assets.Add(customer.seats_go[flightId]);
                // if (customer.seats_go_child != null && customer.seats_go_child.ContainsKey(flightId))
                //     rd.assets.Add(customer.seats_go_child[flightId]);
                if (customer.seats_go.ContainsKey(flightId))
                {
                    var seat = customer.seats_go[flightId];
                    if (lockedSeats.Contains(seat)) 
                    {
                        Console.WriteLine($"Ghế {seat} trên chuyến bay {flightId} đã bị khóa.");
                        return Ok(new { success = false, message = "Error Seat"  });
                    }
                    rd.assets.Add(seat);
                }

                if (customer.seats_go_child != null && customer.seats_go_child.ContainsKey(flightId))
                {
                    var childSeat = customer.seats_go_child[flightId];
                    if (lockedSeats.Contains(childSeat)) 
                    {
                        Console.WriteLine($"Ghế trẻ em {childSeat} trên chuyến bay {flightId} đã bị khóa.");
                        return Ok(new { success = false, message = "Error Seat" });
                    }
                    rd.assets.Add(childSeat);
                }
            }

            requests.Add(rd);
        }

        if (bookingdt.flight_back != null)
            foreach (var flightId in bookingdt.flight_back)
            {
                var rd = new RedisRequest
                {
                    flightId = flightId,
                    ticket_type_go = bookingdt.ticketTypeBack.HasValue && bookingdt.ticketTypeBack.Value
                        ? "Economy"
                        : "Business",
                    assets = new HashSet<string>()
                };
                var lockedSeats = await _flightService.ListSeatLocked(flightId, rd.ticket_type_go);

                foreach (var customer in bookingdt.customers)
                {
                    // if (customer.seats_back != null && customer.seats_back.ContainsKey(flightId))
                    //     rd.assets.Add(customer.seats_back[flightId]);
                    // if (customer.seats_back_child != null && customer.seats_back_child.ContainsKey(flightId))
                    //     rd.assets.Add(customer.seats_back_child[flightId]);
                    
                    if (customer.seats_back != null && customer.seats_back.ContainsKey(flightId))
                    {
                        var seat = customer.seats_back[flightId];
                        if (lockedSeats.Contains(seat))
                        {
                            Console.WriteLine($"Ghế {seat} trên chuyến bay {flightId} đã bị khóa.");
                            return Ok(new {success = false, message = "Error Seat" });
                        }
                        rd.assets.Add(seat);
                    }

                    if (customer.seats_back_child != null && customer.seats_back_child.ContainsKey(flightId))
                    {
                        var childSeat = customer.seats_back_child[flightId];
                        if (lockedSeats.Contains(childSeat))
                        {
                            Console.WriteLine($"Ghế trẻ em {childSeat} trên chuyến bay {flightId} đã bị khóa.");
                            return Ok(new {success = false, message = "Error Seat"  });
                        }
                        rd.assets.Add(childSeat);
                    }
                }

                requests.Add(rd);
            }


        foreach (var rd in requests)
        {
            var result = await _flightService.InsertRedis(rd);
            Console.WriteLine($"Flight ID {rd.flightId} - Result: {result}");
        }

        try
        {
            var ticket = await _flightService.CreateOrder(bookingdt);
            HttpContext.Session.SetString("Ticket", JsonConvert.SerializeObject(ticket));
            return Ok(ticket);
        }
        catch (Exception ex)
        {
            TempData["ErrorMessage"] = "Lỗi: " + ex.Message;
        }

        return null;
    }
    

// public async Task AutoAssignSeatsForCustomers(BookingData bookingData)
// {
//
//     var seatMapsJson = HttpContext.Session.GetString("SeatMapList");
//     var seatMaps = JsonConvert.DeserializeObject<List<SeatMap>>(seatMapsJson) ?? new List<SeatMap>();
//
//     foreach (var flightId in bookingData.flight_go)
//     {
//         var selectedSeatMap = seatMaps.FirstOrDefault(sm => sm.id == flightId);
//     
//         if (selectedSeatMap != null)
//         {
//             await _flightService.LoadAvailableSeats(selectedSeatMap, flightId);
//             
//             await AssignSeatsToCustomers(bookingData, selectedSeatMap, flightId, selectedSeatMap.typeFlight);
//         }
//     }
//
//     if (bookingData.flight_back != null)
//     {
//         foreach (var flightId in bookingData.flight_back)
//         {
//             var selectedSeatMap = seatMaps.FirstOrDefault(sm => sm.id == flightId);
//         
//             if (selectedSeatMap != null)
//             {
//                 await _flightService.LoadAvailableSeats(selectedSeatMap, flightId);
//                 
//                 await AssignSeatsToCustomers(bookingData, selectedSeatMap, flightId, selectedSeatMap.typeFlight);
//             }
//         }
//         
//         foreach (var customer in bookingData.customers)
//         {
//             Console.WriteLine($"Customer: {customer.fullName}, Seats Go: {string.Join(", ", customer.seats_go.Values)}, Seats Back: {string.Join(", ", customer.seats_back.Values)}");
//         }
//     }
//     
//     var updatedSeatMapsJson = JsonConvert.SerializeObject(seatMaps);
//     HttpContext.Session.SetString("SeatMapList", updatedSeatMapsJson);
// }
//
//
// private async Task AssignSeatsToCustomers(BookingData bookingData, SeatMap selectedSeatMap, int flightId, string seatType)
// {
//     foreach (var customer in bookingData.customers)
//     {
//         Seat availableSeat = null;
//
//         // Tìm ghế khả dụng
//         availableSeat = selectedSeatMap.AvailableSeats
//             .FirstOrDefault(s => !s.IsBooked && !s.IsLocked && !s.IsSelected);
//
//         if (availableSeat != null)
//         {
//             // Gán ghế cho khách hàng dựa trên loại ghế
//             switch (seatType)
//             {
//                 case "seats_go":
//                     customer.seats_go[flightId] = availableSeat.Number; // Gán ghế cho khách
//                     break;
//                 case "seats_go_child":
//                     customer.seats_go_child[flightId] = availableSeat.Number; // Gán ghế trẻ em
//                     break;
//                 case "seats_back":
//                     customer.seats_back[flightId] = availableSeat.Number; // Gán ghế cho chuyến bay về
//                     break;
//                 case "seats_back_child":
//                     customer.seats_back_child[flightId] = availableSeat.Number; // Gán ghế trẻ em cho chuyến bay về
//                     break;
//                 default:
//                     // Xử lý trường hợp không hợp lệ nếu cần
//                     break;
//             }
//
//             // Đánh dấu ghế đã được chọn và đặt
//             availableSeat.IsSelected = true; // Đánh dấu ghế đã được chọn
//             availableSeat.IsBooked = true;    // Đánh dấu ghế đã đặt
//         }
//     }
// }


    public IActionResult ConfirmBaggage([FromBody] Dictionary<string, Dictionary<string, int>> baggageSummary)
    {
        var bookingDataJson = HttpContext.Session.GetString("Booking");
        var bookingData = string.IsNullOrEmpty(bookingDataJson)
            ? new BookingData()
            : JsonConvert.DeserializeObject<BookingData>(bookingDataJson);

        if (bookingData != null && bookingData.customers != null)
        {
            foreach (var key in baggageSummary.Keys)
            {
                var customerNameFromSummary = MapBoking.ConvertToFullName(key.Trim());

                var customer = bookingData.customers.FirstOrDefault(c => c.fullName == customerNameFromSummary);
                if (customer == null)
                    return Json(new { success = false, message = $"Not found '{customerNameFromSummary}'" });

                if (baggageSummary.TryGetValue(key, out var bags))
                {
                    customer.bag_go = bags.ContainsKey("bag_go") ? bags["bag_go"] : customer.bag_go;
                    customer.bag_back = bags.ContainsKey("bag_back") ? bags["bag_back"] : customer.bag_back;
                }
            }

            HttpContext.Session.SetString("Booking", JsonConvert.SerializeObject(bookingData));
        }

        return Json(new { success = true });
    }


    private async Task Load()
    {
        await _flightService.MapSeatsToSession(HttpContext);
        var number = HttpContext.Session.GetInt32("SearchNumber") ?? 0;
        ViewBag.SearchNumber = number;
        var searchFlightSession = HttpContext.Session.GetString("SearchFlight");
        if (!string.IsNullOrEmpty(searchFlightSession))
            ViewBag.SearchFlight = JsonConvert.DeserializeObject<SearchFlight>(searchFlightSession);
        else
            ViewBag.SearchFlight = null;

        var dataBooking = HttpContext.Session.GetString("Booking");
        if (!string.IsNullOrEmpty(dataBooking))
            ViewBag.Booking = JsonConvert.DeserializeObject<BookingData>(dataBooking);
        else
            ViewBag.Booking = null;

        var flight = HttpContext.Session.GetString("SeatMapList");
        if (!string.IsNullOrEmpty(flight))
            ViewBag.Flight = JsonConvert.DeserializeObject<List<SeatMap>>(flight);
        else
            ViewBag.Flight = new List<SeatMap>();

        var searchNumberSession = HttpContext.Session.GetInt32("SearchNumber");
        ViewBag.SearchNumber = searchNumberSession ?? 0;

        var selectedFlight = HttpContext.Session.GetString("SelectedFlight");
        if (!string.IsNullOrEmpty(selectedFlight))
            ViewBag.SelectedResults = JsonConvert.DeserializeObject<BidingModel>(selectedFlight);
        else
            ViewBag.SelectedResults = null;

        var customer = HttpContext.Session.GetString("Customers");
        if (!string.IsNullOrEmpty(customer))
            ViewBag.Customer = JsonConvert.DeserializeObject<List<Customer>>(customer);
        else
            ViewBag.Customer = new List<Customer>();

        var isSelectFromSession = HttpContext.Session.GetString("IsComfirmSeat");
        if (!string.IsNullOrEmpty(isSelectFromSession) && bool.TryParse(isSelectFromSession, out var result))
            ViewBag.IsSelect = result;
        else
            ViewBag.IsSelect = false;
    }

    // public decimal CalculateTotalBags()
    // {
    //     var dataBooking = HttpContext.Session.GetString("Booking");
    //     var data =  JsonConvert.DeserializeObject<BookingData>(dataBooking);
    //     int totalBagsGo = 0; 
    //     int totalBagsBack = 0; 
    //     
    //     if (data.customers != null)
    //     {
    //         foreach (var customer in data.customers)
    //         {
    //             totalBagsGo += customer.bag_go;  
    //             totalBagsBack += customer.bag_back; 
    //         }
    //     }
    //     
    //     return (totalBagsGo + totalBagsBack)*200000; 
    // }
}