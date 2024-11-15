using Backend.Service.Interface;
using Backend.Service.ViewModel;
using Microsoft.AspNetCore.Mvc;
using SysAdmin.Service;

namespace SysAdmin.Controllers;

public class AirlineController(ILogger<BaseController> log,IAuthenticationService service, IAirlineService _service) : BaseController(log,service)
{
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.airline, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.View)]
    public IActionResult Index()
    {
        return View();
    }
    
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.airline, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
    public IActionResult Create()
    {
        return PartialView();
    }
    
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.airline, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
    public async Task<IActionResult> Edit(int id)
    {
        var item = await _service.FindById(id);
        return PartialView(item);
    }

    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.airline, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
    public async Task<IActionResult> View(int id)
    {
        var item = await _service.FindById(id);
        return View(item);
    }
    
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.airline, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
    public async Task<IActionResult> Search(string key)
    {
        var rs = await _service.SearchByKey(key);
    
        return Json(rs);
    }
    
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.airline, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
    public async Task<IActionResult> Paging(AirlinePagingResponse model)
    {
        model.Binding(await _service.Paging(model.PagingModel));
    
        return PartialView(model);
    }
    
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.airline, PermissionCode = AuthorizeAttribute.PermissionCode.Write, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]         
    [HttpPost]
    public async Task<IActionResult> DoCreate(AirlineViewModel model)
    {
        try
        {
            var userId = await GetCurrentId();  
            await _service.Insert(model, userId);
            return ShowJsonSuccess(model.id);
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }
    
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.airline, PermissionCode = AuthorizeAttribute.PermissionCode.Update, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
    public async Task<IActionResult> DoEdit(AirlineViewModel model)
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
    
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.airline, PermissionCode = AuthorizeAttribute.PermissionCode.Delete, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
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
