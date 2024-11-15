using Backend.Service.Interface;
using Backend.Service.View;
using Backend.Service.ViewModel;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using sys_i.Common;
using SysAdmin.Service;

namespace SysAdmin.Controllers
{
    public class AirportController(ILogger<BaseController> log,IAuthenticationService service, IAirportService _service, IZoneService zoneService) : BaseController(log,service)
    {

        [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_port, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.View)]
        public async Task<IActionResult> Index()
        {
            return View();
        }

        [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_port, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
        public async Task<IActionResult> Create()
        {
            await Load();
            return PartialView();
        }

        [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_port, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
        public async Task<IActionResult> Edit(int id)
        {
            await Load();
            var item = await _service.FindById(id);
            return PartialView(item);
        }

        [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_port, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
        public async Task<IActionResult> Search(string key)
        {
            var airline = await _service.SearchByKey(key);
            return Json(airline);
        }
        [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_port, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
        public async Task<IActionResult> Paging(AirportPagingResponse model)
        {
            model.Binding(await _service.Paging(model.PagingModel));

            return PartialView(model);
        }

        
        [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_port, PermissionCode = AuthorizeAttribute.PermissionCode.Write, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
        [HttpPost]
        public async Task<IActionResult> DoCreate(AirportViewModel model)
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

        [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_port, PermissionCode = AuthorizeAttribute.PermissionCode.Update, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
        public async Task<IActionResult> DoEdit(AirportViewModel model)
        {

            try
            {
                var userId = await GetCurrentId();  
                var item = _service.Update(model, userId);
                return ShowJsonSuccess();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }
        
        [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.air_port, PermissionCode = AuthorizeAttribute.PermissionCode.Delete, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
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

        public async Task Load()
        {
            var zones = await zoneService.FindAll();
            ViewBag.Zone = new SelectList(zones, "id", "name");
        }
    }
}
