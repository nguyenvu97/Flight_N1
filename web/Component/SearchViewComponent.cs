using BookingFlyWebApp.Models;
using Microsoft.AspNetCore.Mvc;

namespace BookingFlyWebApp.Component;

public class SearchViewComponent : ViewComponent
{
    public async Task<IViewComponentResult> InvokeAsync(string action, object pr1, int? number)
    {
        var searchFlight = pr1 as SearchFlight;
        var selectedResults = HttpContext.Session.GetString("SearchFlight");

        object viewData = null;

        if (action.Equals("ShowSearch", StringComparison.OrdinalIgnoreCase)) viewData = new { selectedResults, number };

        return View(action, viewData);
    }
}