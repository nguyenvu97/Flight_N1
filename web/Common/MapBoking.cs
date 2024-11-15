using BookingFlyWebApp.Models;
using Newtonsoft.Json.Linq;

namespace BookingFlyWebApp.Common;

public static class MapBoking
{
    public static string ConvertToFullName(string formattedName)
    {
        return string.Join(" ", formattedName.Split('_'));
    }

    public static class BookingDataMapper
    {
        // public static BookingData MapToBookingData(JObject selectedResults, List<Customer> customers)
        // {
        //     var flightSelectGo = selectedResults["flightSelectGo"];
        //     var flightSelectBack = selectedResults["flightSelectBack"];
        //
        //     var bookingData = new BookingData
        //     {
        //         flight_go = new List<int>(),
        //         flight_back = new List<int>(),
        //         customers = customers,
        //         ticketTypeGo = flightSelectGo["seats_class"].ToString() == "economy",
        //         ticketTypeBack = flightSelectBack["seats_class"].ToString() == "economy"
        //     };
        //
        //     // Thêm Flight IDs vào flight_go và flight_back
        //     if (flightSelectGo != null)
        //     {
        //         var flightIdsGo = flightSelectGo["FlightIds"].ToString();
        //         bookingData.flight_go.AddRange(flightIdsGo.Split(',').Select(int.Parse));
        //     }
        //
        //     if (flightSelectBack != null)
        //     {
        //         var flightIdsBack = flightSelectBack["FlightIds"].ToString();
        //         bookingData.flight_back.AddRange(flightIdsBack.Split(',').Select(int.Parse));
        //     }
        //
        //     return bookingData;
        // }

        public static BookingData MapToBookingData(JObject selectedResults, List<Customer> customers)
        {
            var flightSelectGo = selectedResults["flightSelectGo"] as JObject;
            var flightSelectBack = selectedResults["flightSelectBack"] as JObject;

            var bookingData = new BookingData
            {
                customers = customers,
                ticketTypeGo = flightSelectGo?["seats_class"]?.ToString() == "economy",
                ticketTypeBack = flightSelectBack != null
                    ? flightSelectBack["seats_class"]?.ToString() == "economy"
                    : null
            };

            if (flightSelectGo != null)
            {
                var flightIdsGo = flightSelectGo["FlightIds"]?.ToString();
                if (!string.IsNullOrEmpty(flightIdsGo))
                {
                    if (flightIdsGo.Contains(","))
                        bookingData.flight_go.AddRange(flightIdsGo.Split(',').Select(int.Parse));
                    else
                        bookingData.flight_go.Add(int.Parse(flightIdsGo));
                }
            }

            if (flightSelectBack != null)
            {
                var flightIdsBack = flightSelectBack["FlightIds"]?.ToString();
                if (!string.IsNullOrEmpty(flightIdsBack))
                {
                    if (flightIdsBack.Contains(","))
                        bookingData.flight_back.AddRange(flightIdsBack.Split(',').Select(int.Parse));
                    else
                        bookingData.flight_back.Add(int.Parse(flightIdsBack));
                }
                else
                {
                    bookingData.flight_back = null;
                }
            }
            else
            {
                bookingData.flight_back = null;
            }

            return bookingData;
        }
    }
}