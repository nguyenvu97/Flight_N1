using BookingFlyWebApp.Models;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace BookingFlyWebApp.Controllers;

public class BookingCartController : Controller
{
    public async Task<IActionResult> ViewDetail()
    {
        await Load();
        ClearFlightSession();
        if (ViewBag.HasData == false) return RedirectToAction("Index", "Home");
        return View();
    }

    public async Task<IActionResult> CartReviewGo()
    {
        await Load();
        ClearFlightSession();
        return PartialView();
    }

    public async Task<IActionResult> CartReviewBack()
    {
        await Load();

        return PartialView();
    }

    private void ClearFlightSession()
    {
        HttpContext.Session.Remove("FlightResults");
        HttpContext.Session.Remove("HasSearched");
        // HttpContext.Session.Remove("SearchNumber");
    }

    private async Task Load()
    {
        var flightGo = HttpContext.Session.GetString("FlightGo");
        var flightBack = HttpContext.Session.GetString("FlightBack");
        if (string.IsNullOrEmpty(flightGo))
        {
            ViewBag.ErrorMessage = "Không tìm thấy thông tin yêu cầu. Vui lòng thử lại!";
            ViewBag.HasData = false;
            Response.Redirect("/Home/Index");
        }
        else
        {
            ViewBag.HasData = true;
            HttpContext.Session.Remove("SelectedFlight");
            var goRs = JsonConvert.DeserializeObject<FlightSelectGo>(flightGo);

            FlightSelectBack backRs = null;

            if (!string.IsNullOrEmpty(flightBack)) backRs = JsonConvert.DeserializeObject<FlightSelectBack>(flightBack);

            BidingModel biding;
            biding = new BidingModel
            {
                flightSelectGo = goRs,
                flightSelectBack = backRs
            };

            HttpContext.Session.SetString("SelectedFlight", JsonConvert.SerializeObject(biding));

            ViewBag.SelectFlight = biding;
        }
    }
}