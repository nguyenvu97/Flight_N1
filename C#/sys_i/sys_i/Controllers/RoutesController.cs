using Backend.Service.Interface;
using Backend.Service.ViewModel;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using SysAdmin.Service;

namespace SysAdmin.Controllers;

public class RoutesController(ILogger<BaseController> log,IAuthenticationService service, IRoutesService _service, IAirportService airportService) : BaseController(log,service)
{
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.routes, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.View)]
    public IActionResult Index()
    { 
        return View();
    }
    
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.routes, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
     public async Task<IActionResult> Create()
     {
         return PartialView();
     }
    
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.routes, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
     public async Task<IActionResult> Edit(int id)
     {
         var item = await _service.FindById(id);
         return PartialView(item);
     }
     
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.routes, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
     public async Task<IActionResult> Search(string key)
     {
         var rs = await _service.SearchByKey(key);
    
         return Json(rs);
     }
      
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.routes, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
     public async Task<IActionResult> Paging(RoutesPagingResponse model)
     {
         model.Binding(await _service.Paging(model.PagingModel));
    
         return PartialView(model);
     }
    
            
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.routes, PermissionCode = AuthorizeAttribute.PermissionCode.Write,ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
     [HttpPost]
     public async Task<IActionResult> DoCreate(RoutesViewModel model)
     {
         try
         {
             var userId = await GetCurrentId();
             var de_port = await airportService.FindById(model.de_a_id);
             var ar_port = await airportService.FindById(model.ar_a_id);
                
             model.BindingField(de_port.name,ar_port.name);
             await _service.Insert(model,userId);
             return ShowJsonSuccess(model.id);
         } 
         catch (Exception ex)
         {
             return ShowJsonError(ex.Message);
         }
        
     }
    
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.routes, PermissionCode = AuthorizeAttribute.PermissionCode.Update,ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
     [HttpPost]
     public async Task<IActionResult> DoEdit(RoutesViewModel model)
     {
         try
         {
             var userId = await GetCurrentId();
             var de_port = await airportService.FindById(model.de_a_id);
             var ar_port = await airportService.FindById(model.ar_a_id);

             model.BindingField(de_port.name, ar_port.name);
             var item = _service.Update(model, userId);
             return ShowJsonSuccess();
         }
         catch (Exception ex)
         {
             return ShowJsonError(ex.Message);
         }
     }
     
      
     [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.routes, PermissionCode = AuthorizeAttribute.PermissionCode.Delete,ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
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