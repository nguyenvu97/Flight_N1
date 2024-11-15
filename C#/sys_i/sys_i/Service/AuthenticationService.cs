using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Newtonsoft.Json;
using sys_i.Common;
using SysAdmin.Models;

namespace SysAdmin.Service
{
    public interface IAuthenticationService
    {
        Task<long> GetCurrentUserId(HttpContext httpContext);
        Task<UserModel?> GetCurrentUserAsync();
        Task<UserModel?> AuthenticateAsync(UserRequest request);
    }
}

namespace SysAdmin.Service
{
    public class AuthenticationService(HttpClient _httpClient,ILogger<AuthenticationService> _logger,
        IHttpContextAccessor _httpContextAccessor,IConfiguration _configuration) : IAuthenticationService
    {

        public async Task<long> GetCurrentUserId(HttpContext httpContext)
        {
            var user = await GetCurrentUserAsync();
            return user?.id ?? 0;
        }

        /// <summary>
        /// Lấy thông tin - check token hợp lệ ???
        /// </summary>
        /// <returns></returns>
        /// <exception cref="InvalidOperationException"></exception>
        public async Task<UserModel?> GetCurrentUserAsync()
        {
            var context = _httpContextAccessor.HttpContext;
            var token = context.Request.Cookies["authToken"]; 
            if (string.IsNullOrEmpty(token))
            {
                context.Response.Cookies.Delete("authToken");

                return null;
            }

            var secretKey = _configuration["Base:TokenSecretKey"];
            if (string.IsNullOrEmpty(secretKey))
            {
                throw new InvalidOperationException("Token secret key không được cấu hình.");
            }

            var jwtTokenValidator = new JwtTokenValidator(secretKey);
            var accessPrincipal = jwtTokenValidator.ValidateToken(token);

            if (accessPrincipal != null)
            {
                var claims = accessPrincipal.Claims.ToList();
                foreach (var claim in claims)
                {
                    Console.WriteLine($"Type: {claim.Type}, Value: {claim.Value}");
                }
                
                return new UserModel
                {
                    id = long.Parse(claims.FirstOrDefault(c => c.Type == "id")?.Value ?? "0"),
                    name = claims.FirstOrDefault(c => c.Type == "name")?.Value ?? string.Empty,
                    role = claims.FirstOrDefault(c => c.Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/role")?.Value ?? string.Empty,
                    sub = claims.FirstOrDefault(c => c.Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier")?.Value ?? string.Empty,
                    iat = int.Parse(claims.FirstOrDefault(c => c.Type == JwtRegisteredClaimNames.Iat)?.Value ?? "0"),
                    exp = int.Parse(claims.FirstOrDefault(c => c.Type == JwtRegisteredClaimNames.Exp)?.Value ?? "0")
                };
            }
            return null;
        }
/// <summary>
/// Kiểm tra tính đúng đắn của token khi Login. - save Cookie
/// </summary>
/// <param name="request"></param>
/// <returns></returns>
/// <exception cref="InvalidOperationException"></exception>

    public async Task<UserModel?> AuthenticateAsync(UserRequest request)
        {
            var requestContent = new StringContent(
                JsonConvert.SerializeObject(request),
                Encoding.UTF8,
                "application/json");

            var urlApi = _configuration["Base:UrlApi"];
            var response = await _httpClient.PostAsync($"{urlApi}/api/v1/login", requestContent);
            response.EnsureSuccessStatusCode();

            var responseContent = await response.Content.ReadAsStringAsync();
            var authResponse = JsonConvert.DeserializeObject<AuthenticationResponse>(responseContent);

            if (authResponse != null && !string.IsNullOrEmpty(authResponse.access_token))
            {
                var secretKey = _configuration["Base:TokenSecretKey"];
                var cookieOptions = new CookieOptions
                {
                    HttpOnly = true,
                    Secure = true,
                    SameSite = SameSiteMode.Strict,
                    Expires = DateTimeOffset.UtcNow.AddDays(300)
                };
        
                _httpContextAccessor.HttpContext.Response.Cookies.Append("authToken", authResponse.access_token, cookieOptions);

                var requestMessage = new HttpRequestMessage(HttpMethod.Get, $"{urlApi}/api/v1/decode");
                requestMessage.Headers.Add("Authorization", $"{authResponse.access_token}");
                
                var response_decode = await _httpClient.SendAsync(requestMessage);
                if (response_decode.IsSuccessStatusCode)
                {
                    var responseContent_decode = await response_decode.Content.ReadAsStringAsync();
                    var decodedMemberData = JsonConvert.DeserializeObject<UserModel>(responseContent_decode);
                    return decodedMemberData;
                }
              
                
            }

            return null;
        }
    }
}


