using Backend.Service.ViewModel;

namespace Backend.Service.Interface;

public interface IAircrarfService
{
    Task<List<AircrarfViewModel>> SearchByKey(string key);
    Task Delete(int id, long userId);
    Task<AircrarfViewModel?> FindById(int id);
    Task Insert(AircrarfViewModel model,long userId);

    Task Update(AircrarfViewModel model,long userId);
    Task<AircrarfResponse> Paging(AircrarfRequest request);
}