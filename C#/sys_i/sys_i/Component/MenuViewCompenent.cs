using Backend.Service.Interface;
using Microsoft.AspNetCore.Mvc;

namespace sys_i.Component;

public class MenuViewComponent( IMenuService _menuService) : ViewComponent
{
    public async Task<IViewComponentResult> InvokeAsync()
    {
        var menus = await _menuService.FindAll();
        return View(menus);
    }
}