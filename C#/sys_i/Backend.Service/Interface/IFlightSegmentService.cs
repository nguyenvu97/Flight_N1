using Backend.Service.ViewModel;

namespace Backend.Service.Interface;

public interface IFlightSegmentService
{
    Task Delete(int id,long userId);
    Task<FlightSegmentViewModel?> FindById(int id);
    Task Insert(List<FlightSegmentViewModel> model, long userId);

    Task Update(FlightSegmentViewModel model,long userId);
    Task<FlightSegmentResponse> PagingSegment(FlightSegmentRequest request);
    
    Task<FlightTripResponse> PagingTrip(FlightTripRequest request);
    Task<List<FlightTripViewModel>> BuildCompleteFlightsAsync();
    Task<List<FlightTripViewModel>> SearchByKey(string key);
}