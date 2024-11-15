using System.Text;
using System.Text.Json.Serialization;
using Backend.Data.Db;
using Backend.Service.Helpper;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Serilog;
using SysAdmin.Service;

var builder = WebApplication.CreateBuilder(args);

var jwtSettings = builder.Configuration.GetSection("Base");
var secretKey = jwtSettings["TokenSecretKey"] ?? throw new ArgumentNullException("TokenSecretKey is not configured");
var key = Encoding.ASCII.GetBytes(secretKey);
// Cấu hình Serilog
Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Debug()
    .WriteTo.Console()
    .WriteTo.File("logs/log-.txt", rollingInterval: RollingInterval.Day)
    .CreateLogger();

builder.Host.UseSerilog();

// Thêm dịch vụ cho MVC
builder.Services.AddControllersWithViews();

// Đăng ký DbContextFactory
//builder.Services.AddDbContextFactory<Context>(options =>
//    options.UseSqlServer(builder.Configuration.GetConnectionString("DB")));
builder.Services.AddDbContextFactory<Context>(options =>
    options.UseMySql(
        builder.Configuration.GetConnectionString("DB"),
        new MySqlServerVersion(new Version(8, 0, 21)) 
    )
);
// Thêm logging
builder.Services.AddLogging(configure => configure.AddConsole());

// Cấu hình loop phân cấp
builder.Services.AddControllers().AddJsonOptions(options =>
{
    options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.Preserve;
});

// Đăng ký DI Container Sevice
builder.Services.AddBackendServices();

builder.Services.AddScoped<IAuthenticationService, AuthenticationService>();

// Cấu hình Authentication
builder.Services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.DefaultSignInScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddCookie(CookieAuthenticationDefaults.AuthenticationScheme, options =>
    {
        options.LoginPath = "/Login/Index";
    })
    .AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = false,
            ValidateAudience = false,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Base:TokenSecretKey"])),
            ClockSkew = TimeSpan.Zero
        };
    });


builder.Services.AddHttpContextAccessor();
builder.Services.AddHttpClient();

var app = builder.Build();

// Cấu hình Middleware
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

// Sử dụng Middleware
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
