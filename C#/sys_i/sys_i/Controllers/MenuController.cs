using Backend.Service.Interface;
using Backend.Service.ViewModel;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using SysAdmin.Service;
namespace SysAdmin.Controllers;

public class MenuController(ILogger<BaseController> log,IAuthenticationService service, IMenuService _service) : BaseController(log,service)
{
    
    
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.menu, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.View)]
        public async Task<IActionResult> Index()
        {
            var menu = await _service.FindAll();
            return View(menu);
        }
        
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.menu, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
    public async Task<IActionResult> Search(string key)
    {
        var rs = await _service.SearchByKey(key);
    
        return Json(rs);
    }

        

    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.menu, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
    public async Task<IActionResult> Create(int? parentId)
    {
        var viewModel = new MenuViewModel();
        if (parentId.HasValue)
        {
            var item = await _service.FindById(parentId.Value); 
            if (item != null)
            {
                viewModel.parent_id = parentId.Value;
                viewModel.parent = new MenuViewModel
                {
                    id = item.id,
                    name = item.name
                };
            }
        }
        
        return PartialView(viewModel);
    }

    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.menu, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
    public async Task<IActionResult> Edit(int id)
    {
        var item = await _service.FindById(id);
        if (item.parent != null)
        {
            item.parent = new MenuViewModel {
                id = item.parent.id,
                name = item.parent.name
            };   
        }
           
        return PartialView(item);
    }
    
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.menu, PermissionCode = AuthorizeAttribute.PermissionCode.Write,ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
    [HttpPost]
    public async Task<IActionResult> DoCreate(MenuViewModel model)
    {
        try
        {
            var userId = await GetCurrentId();
            await _service.Insert(model,userId);
            return ShowJsonSuccess(model.id);
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }

    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.menu, PermissionCode = AuthorizeAttribute.PermissionCode.Update,ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
    [HttpPost]
    public async Task<IActionResult> DoEdit(MenuViewModel model)
    {
        try
        {
            var userId = await GetCurrentId();
            var item = _service.Update(model,userId);
            return ShowJsonSuccess();
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }
        
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.menu, PermissionCode = AuthorizeAttribute.PermissionCode.Delete,ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
    public async Task<IActionResult> DoDelete(int id)
    {
        try
        {
            var userId = await GetCurrentId();
            await _service.Delete(id,userId);
            return ShowJsonSuccess();
        }
        catch (Exception ex)
        {
            return ShowJsonError(ex.Message);
        }
    }

}