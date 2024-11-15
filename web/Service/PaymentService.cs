using BookingFlyWebApp.Models;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;

namespace BookingFlyWebApp.Service;

public class PaymentService
{
    private readonly HttpClient _httpClient;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly string _vnpayApi;

    public PaymentService(HttpClient httpClient, IOptions<ApiSettings> apiSettings,
        IHttpContextAccessor httpContextAccessor)
    {
        _httpClient = httpClient;
        _vnpayApi = apiSettings.Value.VnpayApi;
        _httpContextAccessor = httpContextAccessor;
    }


    public async Task<VnpayRespone> Payment(string OrderNo, bool choose = true)
    {
        try
        {
            var requestUrl = $"{_vnpayApi}/api/v1/vnpay?orderNo={OrderNo}&choose={choose}";
            var response = await _httpClient.GetAsync(requestUrl);
            if (response.IsSuccessStatusCode)
            {
                var responseData = await response.Content.ReadAsStringAsync();
                var payment = JsonConvert.DeserializeObject<VnpayRespone>(responseData);
                return payment;
            }

            return null;
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }
}