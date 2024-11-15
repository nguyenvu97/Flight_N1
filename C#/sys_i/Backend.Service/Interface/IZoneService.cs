using Backend.Service.ViewModel;

namespace Backend.Service.Interface;

public interface IZoneService
{
    Task Delete(int id,long userId);
    Task<ZoneViewModel?> FindById(int id);
    Task Insert(ZoneViewModel model,long userId);
    Task<List<ZoneViewModel?>> FindAll();
    Task Update(ZoneViewModel model,long userId);
}