
using Microsoft.AspNetCore.Mvc;
using sys_i.Common;
using SysAdmin.Service;

namespace SysAdmin.Controllers;

public class BaseController(ILogger<BaseController> log, IAuthenticationService service) : Controller
    {

        public async Task<bool> GetCurrentUser()
        {
            var user = await service.GetCurrentUserAsync();
            return user != null;
        }
        public async Task<long> GetCurrentId()
        {
            return await service.GetCurrentUserId(HttpContext);
        }
        
        //VIEW
        public IActionResult ShowError(string? message = null)
        {
            return View("~/Views/Base/Error.cshtml", message ?? "Lỗi hệ thống!");
        }

        public IActionResult LoginFailed()
        {
            return ShowError("Đăng nhập thất bại!");
        }

        public IActionResult ShowErrorNotPermission()
        {
            return ShowError("Không có quyền!");
        }
        public IActionResult ShowErrorNotNotExist()
        {
            return ShowError("Đối tượng không tồn tại!");
        }
        
        //JSON
        public IActionResult ShowJsonErrorByException(Exception ex)
        {
            var message = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
            return Ok(new { Status = "Fail", Data = message });
        }
        public IActionResult ShowJsonSuccess(object? message = null)
        {
            return Ok(ResponseData.Success(message ?? "Thành công!"));
        }
        public IActionResult ShowJsonError(object? message = null)
        {
            return Ok(ResponseData.Error(message ?? "Nout Found!"));
        }
      
    }