using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Caching.Memory;
using SysAdmin.Models;

namespace SysAdmin.Service
{
    public class AuthorizeAttribute : ActionFilterAttribute
    {
        public enum ValidateViewTypeEnum
        {
            View,
            PartialView,
            Json
        }

        public enum DirectoryModuleEnum
        {
            air_carf,
            airline,
            flight,
            home,
            routes,
            air_port,
            menu,
            zone,
            flight_segment
        }

        public enum PermissionCode
        {
            Read,
            Write,
            Delete,
            Update
        }

        public class ValidateModuleAttribute : ActionFilterAttribute
        {
            public ValidateViewTypeEnum ViewType { get; set; } = ValidateViewTypeEnum.Json;
            public DirectoryModuleEnum Module { get; set; }
            public PermissionCode PermissionCode { get; set; }

            /// <summary>
            /// kiểm tra quyền truy cập trước Controller
            /// </summary>
            /// <param name="context"></param>
            /// <param name="next"></param>
            public override async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
            {
                var authenticationService = context.HttpContext.RequestServices.GetRequiredService<IAuthenticationService>();
                var cache = context.HttpContext.RequestServices.GetRequiredService<IMemoryCache>();
                var logger = context.HttpContext.RequestServices.GetRequiredService<ILogger<AuthorizeAttribute>>();

                var user = await authenticationService.GetCurrentUserAsync();

                if (user == null)
                {
                    var returnUrl = context.HttpContext.Request.Path.ToString();
                    cache.Set("ReturnUrl", returnUrl, TimeSpan.FromMinutes(1));
                    context.Result = new RedirectToActionResult("Index", "Login", null);
                    return;
                }

                var hasPermission = await CheckUserPermission(authenticationService, user);
                if (!hasPermission)
                {
                    context.Result = new ForbidResult();
                    return;
                }

                logger.LogInformation($"User {user.id} has access to {Module} with permission {PermissionCode}.");
                
                await next();
            }

            /// <summary>
            /// Kiểm tra quyền truy cập module
            /// </summary>
            /// <param name="authenticationService"></param>
            /// <param name="user"></param>
            /// <returns></returns>
            private async Task<bool> CheckUserPermission(IAuthenticationService authenticationService, UserModel user)
            {
                var permissions = new Dictionary<long, Dictionary<DirectoryModuleEnum, List<PermissionCode>>>
                {
                    { user.id, new Dictionary<DirectoryModuleEnum, List<PermissionCode>>
                        {
                            { DirectoryModuleEnum.flight, new List<PermissionCode> { PermissionCode.Read, PermissionCode.Write,PermissionCode.Update,PermissionCode.Delete  } },
                            { DirectoryModuleEnum.air_carf, new List<PermissionCode> { PermissionCode.Read, PermissionCode.Write,PermissionCode.Update,PermissionCode.Delete  } },
                            { DirectoryModuleEnum.air_port, new List<PermissionCode> { PermissionCode.Read, PermissionCode.Write,PermissionCode.Update,PermissionCode.Delete  } },
                            { DirectoryModuleEnum.airline, new List<PermissionCode> { PermissionCode.Read, PermissionCode.Write,PermissionCode.Update,PermissionCode.Delete  } },
                            { DirectoryModuleEnum.routes, new List<PermissionCode> { PermissionCode.Read, PermissionCode.Write,PermissionCode.Update,PermissionCode.Delete } },
                            { DirectoryModuleEnum.menu, new List<PermissionCode> { PermissionCode.Read, PermissionCode.Write,PermissionCode.Update,PermissionCode.Delete } },
                            { DirectoryModuleEnum.zone, new List<PermissionCode> { PermissionCode.Read, PermissionCode.Write,PermissionCode.Update,PermissionCode.Delete  } },
                            { DirectoryModuleEnum.flight_segment, new List<PermissionCode> { PermissionCode.Read, PermissionCode.Write,PermissionCode.Update,PermissionCode.Delete  } },
                            { DirectoryModuleEnum.home, new List<PermissionCode> { PermissionCode.Read } }
                        }
                    }
                };

                if (permissions.TryGetValue(user.id, out var userPermissions))
                {
                    if (userPermissions.TryGetValue(Module, out var allowedPermissions))
                    {
                        return allowedPermissions.Contains(PermissionCode);
                    }
                }

                return false;
            }
        }
    }
}
