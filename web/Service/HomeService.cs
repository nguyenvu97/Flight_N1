using BookingFlyWebApp.Models;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;

namespace BookingFlyWebApp.Service
{
    public class HomeService
    {
        private readonly HttpClient _httpClient;
        private readonly string _urlApi; 
        
        public HomeService(HttpClient httpClient, IOptions<ApiSettings> apiSettings) 
        {
            _httpClient = httpClient; 
            _urlApi = apiSettings.Value.UrlApi;
        }

        public async Task<Dictionary<string, List<AirportViewModel>>> GetAllAirportsAsync()
        {
            try
            {
                var url = $"{_urlApi}/api/v1/Airport/all";
                var response = await _httpClient.GetAsync(url);
                response.EnsureSuccessStatusCode();
                var jsonData = await response.Content.ReadAsStringAsync();
                var airports = JsonConvert.DeserializeObject<Dictionary<string, List<AirportViewModel>>>(jsonData);
                return airports;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                throw;
            }
           
        }
    }
}