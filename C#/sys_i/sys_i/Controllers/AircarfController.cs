using Backend.Service.Interface;
using Backend.Service.ViewModel;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using SysAdmin.Service;


namespace SysAdmin.Controllers;

public class AircarfController (ILogger<BaseController> log,IAuthenticationService service, IAircrarfService _service, IAirlineService airlineService) : BaseController(log, service)
{
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_carf, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.View)]
     public IActionResult Index()
     {
         return View();
     }
    
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_carf, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
     public async Task<IActionResult> Create()
     {
            return PartialView();
     }
    
     public async Task<IActionResult> Edit(int id)
     {
         var item = await _service.FindById(id);
         return PartialView(item);
     }
     
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_carf, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
     public async Task<IActionResult> View(int id)
     {
         var item = await _service.FindById(id);
         return PartialView(item);
     }
    
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_carf, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
     public async Task<IActionResult> Search(string key)
     {
         var rs = await _service.SearchByKey(key);
    
         return Json(rs);
     }
            
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_carf, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
     public async Task<IActionResult> Paging(AircrarfPagingResponse model)
     {
         model.Binding(await _service.Paging(model.PagingModel));
    
         return PartialView(model);
     }
    
            
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_carf, PermissionCode = AuthorizeAttribute.PermissionCode.Write, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
     [HttpPost]
     public async Task<IActionResult> DoCreate(AircrarfViewModel model)
     {
         try
         {
             var userId = await GetCurrentId();  
             var airline = airlineService.FindById(model.airline_id);
             if (airline == null)
             {
                 return ShowJsonError();
             }
    
             await _service.Insert(model,userId);
             return ShowJsonSuccess(model.id);
         }
         catch (Exception e)
         {
             Console.WriteLine(e);
             throw;
         }
     }
    
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_carf, PermissionCode = AuthorizeAttribute.PermissionCode.Update, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
     [HttpPost]
     public async Task<IActionResult> DoEdit(AircrarfViewModel model)
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
            
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_carf, PermissionCode = AuthorizeAttribute.PermissionCode.Delete, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
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
            
     private async Task Loads()
     {
         var all = await airlineService.FindAll();
         ViewBag.Airline =  new SelectList(all, "id", "name");
     }           
     
}
