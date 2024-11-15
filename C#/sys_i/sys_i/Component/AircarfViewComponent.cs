using Backend.Service.Interface;
using Microsoft.AspNetCore.Mvc;

namespace sys_i.Component;

public class AircarfViewComponent(IAircrarfService service):ViewComponent
{
    public async Task<IViewComponentResult> InvokeAsync(string action, object pr1)
    {
        object? viewData = null;
        if (action.Equals("ShowName", StringComparison.OrdinalIgnoreCase))
        {
            viewData = await service.FindById((int)pr1);
        }
        return View(action, viewData);
    }
}
