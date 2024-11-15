namespace BookingFlyWebApp.Common;

public static class Converter
{
    public static string ConvertDate(string dateStr)
    {
        // Kiểm tra xem chuỗi có null hoặc rỗng hay không
        if (string.IsNullOrEmpty(dateStr))
            throw new ArgumentException("Date string cannot be null or empty.", nameof(dateStr));

        // Chia tách chuỗi theo dấu '-'
        var parts = dateStr.Split('-');
        if (parts.Length != 3) throw new FormatException("Date string is not in the expected format yyyy-MM-dd.");

        var year = parts[0];
        var month = parts[1];
        var day = parts[2];
        return $"{day}/{month}/{year}";
    }

    public static string CalculateDuration(DateTime departureTime, DateTime arrivalTime)
    {
        var duration = arrivalTime - departureTime;

        var totalHours = (int)duration.TotalHours;
        var minutes = duration.Minutes;

        var days = totalHours / 24;
        var remainingHours = totalHours % 24;
        if (days > 0)
            return $"{days} ngày {remainingHours} giờ {minutes} phút";
        return $"{remainingHours} giờ {minutes} phút";
    }

    public static string ConvertFlightIdsToString(List<int> flightIds)
    {
        // Chuyển đổi danh sách thành chuỗi ngăn cách bằng dấu phẩy
        return string.Join(",", flightIds);
    }
}