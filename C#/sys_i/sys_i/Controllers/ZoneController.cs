using Backend.Service.Interface;
using Backend.Service.ViewModel;
using Microsoft.AspNetCore.Mvc;
using SysAdmin.Service;

namespace SysAdmin.Controllers;

public class ZoneController(ILogger<BaseController> log,IAuthenticationService service, IZoneService _service) : BaseController(log,service)
{
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.zone, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.View)]
     public async Task<IActionResult> Index()
     {
         var item = await _service.FindAll();
         return View(item);
     }
    
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.zone, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
     public async Task<IActionResult> Create()
     {
         return PartialView();
     }
    
     public async Task<IActionResult> Edit(int id)
     {
         var item = await _service.FindById(id);
         return PartialView(item);
     }
     
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.zone, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
     public async Task<IActionResult> View(int id)
     {
         var item = await _service.FindById(id);
         return PartialView(item);
     }
     
            
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.zone, PermissionCode = AuthorizeAttribute.PermissionCode.Write, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
     [HttpPost]
     public async Task<IActionResult> DoCreate(ZoneViewModel model)
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
    
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.zone, PermissionCode = AuthorizeAttribute.PermissionCode.Update, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
     [HttpPost]
     public async Task<IActionResult> DoEdit(ZoneViewModel model)
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
            
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.zone, PermissionCode = AuthorizeAttribute.PermissionCode.Delete, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
     public async Task<IActionResult> DoDelete(int id)
     {
         try
         {
             var userId = await GetCurrentId();  
             await _service.Delete(id, userId);
             return ShowJsonSuccess();
         }
         catch (Exception ex)
         {
             return ShowJsonError(ex.Message);
         }
     }
     

                
    
}