using Backend.Service.ViewModel;

namespace Backend.Service.Interface;

public interface IRoutesService
{
    Task<List<RoutesViewModel>> SearchByKey(string key);
    Task Delete(int id,long userId);
    Task<RoutesViewModel?> FindById(int id);
    Task Insert(RoutesViewModel model,long userId);

    Task Update(RoutesViewModel model,long userId);
    Task<RoutestResponse> Paging(RoutestRequest request);
    
}