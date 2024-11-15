using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using SysAdmin.Service;
using SysAdmin.Models;
using System.Threading.Tasks;

namespace SysAdmin.Controllers
{
    public class LoginController (ILogger<BaseController> log,IAuthenticationService _authenticationService,IMemoryCache _cache): BaseController(log, _authenticationService)
    {
        
        [HttpGet]
        public async Task <IActionResult> Index(string returnUrl = null)
        {
            
             var user = await GetCurrentUser();

             if (user == null)
             {
                 return RedirectToAction("Index", "Login");
             }
            // if (string.IsNullOrEmpty(token))
            // {
            //
            //     return RedirectToAction("Index", "Home");
            // }
            
            if (!string.IsNullOrEmpty(returnUrl))
            {
                _cache.Set("ReturnUrl", returnUrl);
            }

            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Login(UserRequest request)
        {
            try
            {
                var user = await _authenticationService.AuthenticateAsync(request);
                if (user != null)
                {
                    if (_cache.TryGetValue("ReturnUrl", out string returnUrl) && !string.IsNullOrEmpty(returnUrl))
                    {
                        _cache.Remove("ReturnUrl");
                        return Redirect(returnUrl);
                    }

                    return RedirectToAction("Index", "Home");
                }
                return LoginFailed();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }
    }
}