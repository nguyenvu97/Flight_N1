using BookingFlyWebApp.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using BookingFlyWebApp.Service;
using Newtonsoft.Json;

namespace BookingFlyWebApp.Controllers
{
    public class HomeController(HomeService _homeService, FlightService _flightService) : Controller
    {


        public async Task<IActionResult> Index()
        {
            var regions = await _homeService.GetAllAirportsAsync();
            ViewBag.Airports = regions;
               // HttpContext.Session.SetString("Airports", Newtonsoft.Json.JsonConvert.SerializeObject(regions));
            return View();
        }

        public async Task<IActionResult> FlightSearchForm()
        {
            return PartialView();
        }
    }
}
