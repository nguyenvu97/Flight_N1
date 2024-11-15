using BookingFlyWebApp.Models;
using Newtonsoft.Json;

namespace BookingFlyWebApp.Service;

public class ShopingService
{
    private readonly FlightService _flightService;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public ShopingService(IHttpContextAccessor httpContextAccessor, FlightService flightService)
    {
        _httpContextAccessor = httpContextAccessor;
        _flightService = flightService;
    }

    public async Task AutoAssignSeatsForCustomers(BookingData bookingData)
    {
        var session = _httpContextAccessor.HttpContext?.Session;
        var seatMapsJson = session.GetString("SeatMapList");
        var seatMaps = JsonConvert.DeserializeObject<List<SeatMap>>(seatMapsJson) ?? new List<SeatMap>();

        foreach (var flightId in bookingData.flight_go)
        {
            var selectedSeatMap = seatMaps.FirstOrDefault(sm => sm.id == flightId);

            if (selectedSeatMap != null)
            {
                await _flightService.LoadAvailableSeats(selectedSeatMap, flightId);
                await AssignSeatsToCustomers(bookingData, selectedSeatMap, flightId, selectedSeatMap.typeFlight);
            }
        }

        if (bookingData.flight_back != null)
        {
            foreach (var flightId in bookingData.flight_back)
            {
                var selectedSeatMap = seatMaps.FirstOrDefault(sm => sm.id == flightId);

                if (selectedSeatMap != null)
                {
                    await _flightService.LoadAvailableSeats(selectedSeatMap, flightId);
                    await AssignSeatsToCustomers(bookingData, selectedSeatMap, flightId, selectedSeatMap.typeFlight);
                }
            }

            foreach (var customer in bookingData.customers)
                Console.WriteLine(
                    $"Customer: {customer.fullName}, Seats Go: {string.Join(", ", customer.seats_go.Values)}, Seats Back: {string.Join(", ", customer.seats_back.Values)}");
        }

        var updatedSeatMapsJson = JsonConvert.SerializeObject(seatMaps);
        session.SetString("SeatMapList", updatedSeatMapsJson);
    }

    private async Task AssignSeatsToCustomers(BookingData bookingData, SeatMap selectedSeatMap, int flightId,
        string seatType)
    {
        foreach (var customer in bookingData.customers)
        {
            Seat availableSeat = null;

            if ((seatType == "seats_go" && customer.seats_go.ContainsKey(flightId)) ||
                (seatType == "seats_go_child" && customer.seats_go_child.ContainsKey(flightId)) ||
                (seatType == "seats_back" && customer.seats_back.ContainsKey(flightId)) ||
                (seatType == "seats_back_child" && customer.seats_back_child.ContainsKey(flightId)))
                continue;

            availableSeat = selectedSeatMap.AvailableSeats
                .FirstOrDefault(s => !s.IsBooked && !s.IsLocked && !s.IsSelected);

            if (availableSeat != null)
            {
                switch (seatType)
                {
                    case "seats_go":
                        customer.seats_go[flightId] = availableSeat.Number;
                        break;
                    case "seats_go_child":
                        customer.seats_go_child[flightId] = availableSeat.Number;
                        break;
                    case "seats_back":
                        customer.seats_back[flightId] = availableSeat.Number;
                        break;
                    case "seats_back_child":
                        customer.seats_back_child[flightId] = availableSeat.Number;
                        break;
                }

                availableSeat.IsSelected = true;
                // availableSeat.IsBooked = true;
            }
        }
    }
}