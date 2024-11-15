using BookingFlyWebApp.Models;
using BookingFlyWebApp.Service;

var builder = WebApplication.CreateBuilder(args);
builder.Services.Configure<ApiSettings>(builder.Configuration.GetSection("Base"));
builder.Services.AddScoped<HomeService>();
builder.Services.AddScoped<FlightService>();
builder.Services.AddScoped<ShopingService>();
builder.Services.AddScoped<PaymentService>();
builder.Services.AddHttpClient();
// builder.Services.AddStackExchangeRedisCache(options =>
// {
//     options.Configuration = builder.Configuration.GetSection("Redis")["ConnectionString"];
// });

builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});
// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddHttpContextAccessor();
var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();
app.UseSession();

app.UseAuthorization();

app.MapControllerRoute(
    "default",
    "{controller=Home}/{action=Index}/{id?}");

app.Run();