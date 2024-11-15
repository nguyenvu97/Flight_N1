using Backend.Service.ViewModel;

namespace Backend.Service.Interface;

public interface IAirlineService
{
    Task Delete(int id,long userId);
    Task<AirlineViewModel?> FindById(int id);
    Task Insert(AirlineViewModel model,long userId);
    Task<List<AirlineViewModel>> SearchByKey(string key);
    Task<List<AirlineViewModel?>> FindAll();
    Task Update(AirlineViewModel model,long userId);
    Task<AirlineResponse> Paging(AirlineRequest request);
}