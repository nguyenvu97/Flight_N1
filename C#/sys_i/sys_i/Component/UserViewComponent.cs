
using Microsoft.AspNetCore.Mvc;
using SysAdmin.Service;

namespace sys_i.Component;

public class UserViewComponent(IAuthenticationService service):ViewComponent
{
    public async Task<IViewComponentResult> InvokeAsync(string action)
    {
        var user = await service.GetCurrentUserAsync();
        return View(action,user);
    }
}
