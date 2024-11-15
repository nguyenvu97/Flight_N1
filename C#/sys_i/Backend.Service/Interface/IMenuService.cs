using Backend.Service.ViewModel;

namespace Backend.Service.Interface;

public interface IMenuService
{
    Task<List<MenuViewModel>> SearchByKey(string key);
    Task Delete(int id,long userId);
    Task<List<MenuViewModel>> FindAll();
    Task<MenuViewModel?> FindById(int id);
    Task Insert(MenuViewModel model,long userId);
    Task Update(MenuViewModel model,long userId);
}