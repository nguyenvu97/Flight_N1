using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

public class JwtTokenValidator
{
    private readonly string _secretKey;

    public JwtTokenValidator(string secretKey)
    {
        _secretKey = secretKey;
    }

    public ClaimsPrincipal ValidateToken(string token)
    {
        var handler = new JwtSecurityTokenHandler();
        var key = Convert.FromBase64String(_secretKey); 

        var validationParameters = new TokenValidationParameters
        {
            ValidateIssuer = false, 
            ValidateAudience = false,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(key),
            ClockSkew = TimeSpan.Zero 
        };

        try
        {
            var principal = handler.ValidateToken(token, validationParameters, out var securityToken);
            
            return principal;
        }
        catch (Exception e)
        {
            Console.WriteLine(e.Message);
            throw;
        }
    }
}

public class Program
{
    public static void Main(string[] args)
    {
        var secretKey = "404E635266556A586E3272357538782F413F4428472B4B6250645367566B5970"; 
        var jwtTokenValidator = new JwtTokenValidator(secretKey);

        var token = "eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoxLCJpZCI6MSwic3ViIjoidGhhaUBnbWFpbC5jb20iLCJpYXQiOjE3MjI1NTI2NTQsImV4cCI6MTcyMjYzOTA1NH0.uF5bvJ9nebpBCUYFuOLFa8RoAd8MUJNRpIHvOK809LU";

        var principal = jwtTokenValidator.ValidateToken(token);

        if (principal != null)
        {
            Console.WriteLine("Token hợp lệ.");
        }
        else
        {
            Console.WriteLine("Token không hợp lệ hoặc đã hết hạn.");
        }
    }
}
