using BookingFlyWebApp.Common;
using BookingFlyWebApp.Models;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace BookingFlyWebApp.Controllers;

public class InformationController : Controller
{
    public async Task<IActionResult> InformationCustomer()
    {
        await Load();
        return View();
    }

    public async Task<IActionResult> InputformCustomer()
    {
        await Load();
        return PartialView();
    }

    public async Task<IActionResult> ContactCustomer()
    {
        await Load();
        return PartialView();
    }

    public IActionResult SaveBookingData([FromBody] List<Customer> bookingData)
    {
        if (bookingData == null) return BadRequest("Dữ liệu không hợp lệ.");

        HttpContext.Session.SetString("Customers", JsonConvert.SerializeObject(bookingData));

        var selectedResultsJson = HttpContext.Session.GetString("SelectedFlight");
        var customerListJson = HttpContext.Session.GetString("Customers");

        if (selectedResultsJson == null || customerListJson == null)
            return BadRequest("Fail");

        var selectedResults = JObject.Parse(selectedResultsJson);
        var customerList = JsonConvert.DeserializeObject<List<Customer>>(customerListJson);

        var booking = MapBoking.BookingDataMapper.MapToBookingData(selectedResults, customerList);
        HttpContext.Session.SetString("Booking", JsonConvert.SerializeObject(booking));

        return Ok(new { message = "Dữ liệu đã được lưu thành công!" });
    }

    public async Task Load()
    {
        var searchFlightSession = HttpContext.Session.GetString("SearchFlight");
        if (!string.IsNullOrEmpty(searchFlightSession))
            ViewBag.SearchFlight = JsonConvert.DeserializeObject<SearchFlight>(searchFlightSession);

        var searchNumberSession = HttpContext.Session.GetInt32("SearchNumber");
        ViewBag.SearchNumber = searchNumberSession ?? 0;
        var selectedFlight = HttpContext.Session.GetString("SelectedFlight");
        var selectedResults = JsonConvert.DeserializeObject<BidingModel>(selectedFlight);
        ViewBag.SelectedResults = selectedResults;
    }
}