using BookingFlyWebApp.Common;
using BookingFlyWebApp.Models;
using BookingFlyWebApp.Service;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace BookingFlyWebApp.Controllers;

public class FlightSearchController : Controller
{
    private readonly FlightService _flightService;
    private readonly HomeService _homeService;


    #region #search

    public async Task<IActionResult> Search(SearchFlight searchFlight, int number)
    {
        try
        {
            if (string.IsNullOrEmpty(searchFlight.endDate) || searchFlight.endDate == "undefined-undefined-")
                searchFlight.endDate = string.Empty;

            var flightResponse = await _flightService.SearchFlight(searchFlight, number);

            if (flightResponse == null)
            {
                ViewBag.ErrorMessage = "Không tìm thấy chuyến bay nào phù hợp với yêu cầu của bạn. Vui lòng thử lại!";
                ClearFlightSession();
                ViewBag.HasData = false;
            }
            else
            {
                UpdateFlightSession(searchFlight, number, flightResponse);
            }

            var redirectUrl = Url.Action("IndexGo");
            return Json(new { redirectUrl });
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            return StatusCode(500, "Internal server error");
        }
    }

    #endregion

    #region #select_go_flight

    public async Task<IActionResult> SelectGo(FlightSelectionRequest flightSelection)
    {
        var flightResultsSession = HttpContext.Session.GetString("FlightResults");

        if (string.IsNullOrEmpty(flightResultsSession))
            return Json(new { success = false, message = "No flight results found in the session." });

        var flightResults = JsonConvert.DeserializeObject<FlightResponse>(flightResultsSession);
        FlightSelectGo flightGo;

        var goFlight = flightResults.flight_go.FirstOrDefault(f => f.id == flightSelection.flightId);

        if (goFlight != null)
        {
            var parentFlightId = goFlight.id;
            var childFlightIds = new List<int>();
            if (goFlight.flights != null) childFlightIds = goFlight.flights.Select(f => f.id).ToList();

            flightGo = new FlightSelectGo
            {
                adultQuantyti = flightResults.adultQuantity,
                childtQuantyti = flightResults.childQuantity,
                totalPrice = flightSelection.totalPrice,
                seats_class = flightSelection.seatsClass,
                flight_go = goFlight,
                FlightIds = Converter.ConvertFlightIdsToString(new List<int> { parentFlightId }.Concat(childFlightIds)
                    .ToList())
            };
            var IsSelected = true;

            HttpContext.Session.SetString("FlightGo", JsonConvert.SerializeObject(flightGo));
            Console.Write(flightGo);
            var redirectUrl = flightSelection.number == 1
                ? Url.Action("ViewDetail", "BookingCart")
                : Url.Action("IndexBack");
            return Json(new { success = true, redirectUrl });
            //return Json(flightGo);
        }

        return Json(new { success = false, message = "Flight not found." });
    }

    #endregion

    #region #select_back_flight

    public async Task<IActionResult> SelectBack(FlightSelectionRequest flightSelection)
    {
        var flightResultsSession = HttpContext.Session.GetString("FlightResults");

        if (string.IsNullOrEmpty(flightResultsSession))
            return Json(new { success = false, message = "No flight results found in the session." });

        var flightResults = JsonConvert.DeserializeObject<FlightResponse>(flightResultsSession);
        FlightSelectBack flightBack;

        var backFlight = flightResults.flight_back.FirstOrDefault(f => f.id == flightSelection.flightId);

        if (backFlight != null)
        {
            var parentFlightId = backFlight.id;
            var childFlightIds = new List<int>();
            if (backFlight.flights != null) childFlightIds = backFlight.flights.Select(f => f.id).ToList();
            flightBack = new FlightSelectBack
            {
                adultQuantyti = flightResults.adultQuantity,
                childtQuantyti = flightResults.childQuantity,
                totalPrice = flightSelection.totalPrice,
                seats_class = flightSelection.seatsClass,
                flight_back = backFlight,
                FlightIds = Converter.ConvertFlightIdsToString(new List<int> { parentFlightId }.Concat(childFlightIds)
                    .ToList())
            };

            HttpContext.Session.SetString("FlightBack", JsonConvert.SerializeObject(flightBack));
            var redirectUrl = Url.Action("ViewDetail", "BookingCart");

            return Json(new { success = true, redirectUrl });
            //return Json(flightBack);
        }

        return Json(new { success = false, message = "Flight not found." });
    }

    #endregion

    // public IActionResult SavePassengerCount(int adultQuantity, int childQuantity)
    //     {
    //         HttpContext.Session.SetInt32("AdultQuantity", adultQuantity);
    //         HttpContext.Session.SetInt32("ChildQuantity", childQuantity);
    //         return Ok();
    //     }
    private async Task Load()
    {
        var flightResultsSession = HttpContext.Session.GetString("FlightResults");
        if (string.IsNullOrEmpty(flightResultsSession))
        {
            ViewBag.ErrorMessage = "Không tìm thấy thông tin yêu cầu. Vui lòng thử lại!";
            ViewBag.HasData = false;
        }
        else
        {
            var flightResults = JsonConvert.DeserializeObject<FlightResponse>(flightResultsSession);
            ViewBag.FlightResults = flightResults;
            ViewBag.HasData = true;
        }

        var searchFlightSession = HttpContext.Session.GetString("SearchFlight");
        if (!string.IsNullOrEmpty(searchFlightSession))
            ViewBag.SearchFlight = JsonConvert.DeserializeObject<SearchFlight>(searchFlightSession);

        var searchNumberSession = HttpContext.Session.GetInt32("SearchNumber");
        ViewBag.SearchNumber = searchNumberSession ?? 0;
    }

    private void ClearFlightSession()
    {
        HttpContext.Session.Remove("FlightResults");
        HttpContext.Session.Remove("HasSearched");
    }

    private void UpdateFlightSession(SearchFlight searchFlight, int number, FlightResponse flightResponse)
    {
        HttpContext.Session.Remove("FlightGo");
        HttpContext.Session.Remove("IsComfirmSeat");
        HttpContext.Session.Remove("FlightBack");
        HttpContext.Session.Remove("FlightResults");
        HttpContext.Session.Remove("HasSearched");
        HttpContext.Session.SetString("SearchFlight", JsonConvert.SerializeObject(searchFlight));
        HttpContext.Session.SetInt32("SearchNumber", number);
        HttpContext.Session.SetString("FlightResults", JsonConvert.SerializeObject(flightResponse));
        HttpContext.Session.SetString("HasSearched", "true");
    }

    #region #component_view

    public FlightSearchController(HomeService homeService, FlightService flightService)
    {
        _homeService = homeService;
        _flightService = flightService;
    }

    public async Task<IActionResult> IndexGo()
    {
        if (ViewBag.HasData == false) return RedirectToAction("Index", "Home");
        await Load();
        var airports = await _homeService.GetAllAirportsAsync();
        ViewBag.Airports = airports;

        return View();
    }

    public async Task<IActionResult> IndexBack()
    {
        if (ViewBag.HasData == false) return RedirectToAction("Index", "Home");
        await Load();
        var airports = await _homeService.GetAllAirportsAsync();
        ViewBag.Airports = airports;


        return View();
    }

    public async Task<IActionResult> FlightGo()
    {
        await Load();
        ViewBag.ShowFlightBack = true;
        return PartialView();
    }

    public async Task<IActionResult> FlightBack()
    {
        await Load();
        return PartialView();
    }

    public async Task<IActionResult> FlightSearchFormBooking()
    {
        var airports = await _homeService.GetAllAirportsAsync();
        ViewBag.Airports = airports;
        return PartialView();
    }

    #endregion
}