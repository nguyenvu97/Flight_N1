using BookingFlyWebApp.Models;
using BookingFlyWebApp.Service;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace BookingFlyWebApp.Controllers;

public class PaymentController(FlightService _flightService, PaymentService _paymentService) : Controller
{
    public async Task<IActionResult> Payment()
    {
        await Load();
        return View();
    }

    public async Task<IActionResult> PaymentVnpay(string orderNo, bool choose = true)
    {
        var payment = await _paymentService.Payment(orderNo, choose);
        return Json(payment);
    }

    // public async Task<IActionResult> clearSecsion()
    // {
    //     await Remove();
    //     return Ok("200");
    // }
    //
    // private async Task Remove()
    // {
    //     HttpContext.Session.Remove("Booking");
    //     HttpContext.Session.Remove("Customers");
    //     HttpContext.Session.Remove("SeatMapList");
    //     HttpContext.Session.Remove("IsComfirmSeat");
    //     HttpContext.Session.Remove("Ticket");
    // }

    private async Task Load()
    {
        var searchFlightSession = HttpContext.Session.GetString("SearchFlight");
        var number = HttpContext.Session.GetInt32("SearchNumber") ?? 0;
        ViewBag.SearchNumber = number;
        if (!string.IsNullOrEmpty(searchFlightSession))
            ViewBag.SearchFlight = JsonConvert.DeserializeObject<SearchFlight>(searchFlightSession);
        else
            ViewBag.SearchFlight = null;

        var ticket = HttpContext.Session.GetString("Ticket");
        ViewBag.Ticket = JsonConvert.DeserializeObject<TicketDto>(ticket);
    }
}