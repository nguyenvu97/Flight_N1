

using Backend.Service.Interface;
using Backend.Service.ViewModel;
using Microsoft.AspNetCore.Mvc;
using SysAdmin.Service;

namespace SysAdmin.Controllers;

public class FlightSegmentController (ILogger<BaseController> log,IAuthenticationService service, IFlightSegmentService _service,
    IAircrarfService aircrarfService, IRoutesService routesService, IAirportService airportService) : BaseController(log,service)
{
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.flight_segment, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.View)]
   public async Task <IActionResult> Index()
   {
       return View();
   }
    
    [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.flight_segment, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.View)]
    public async Task <IActionResult> IndexSegment()
    {
        return View();
    }
   
   [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.flight_segment, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
   public async Task<IActionResult> Create()
   {
       return PartialView();
   }
  
   [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.flight_segment, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
   public async Task<IActionResult> Edit(int id)
   {
       var item = await _service.FindById(id);
       return PartialView(item);
   }
    
   [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.flight_segment, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
   // public async Task<IActionResult> View(int id)
   // {
   //     var item = await _service.FindById(id);
   //     return PartialView(item);
   // }
   //
   public async Task<IActionResult> View(int id)
   {
       var flights = await _service.BuildCompleteFlightsAsync();
       var flight = flights.FirstOrDefault(f => f.TripId == id);

       if (flight == null)
       {
           return NotFound();
       }

       return PartialView(flight.Segments);
   }
   
   
   public async Task<IActionResult> PagingSegment(FlightSegmentPagingResponse model)
   {
       model.Binding(await _service.PagingSegment(model.PagingModel));
       return PartialView(model);
   }

   
   
   
   [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.flight_segment, PermissionCode = AuthorizeAttribute.PermissionCode.Read, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.PartialView)]
   public async Task<IActionResult> Search(string key)
   {
       var airline = await _service.SearchByKey(key);
       return Json(airline);
   }

   public async Task<IActionResult> PagingTrip(FlightTripPagingResponse model)
   {
       model.Binding(await _service.PagingTrip(model.PagingModel));
       var abc = Json(model);
       return PartialView(model);
   }

   
   
//Test binding data
   // public List<FlightSegmentViewModel> data()
   // {
   //    var model = new List<FlightSegmentViewModel>
   //     {
   //         new FlightSegmentViewModel
   //         {
   //             air_id = 1,
   //             route_id = 1,
   //             de_time = DateTime.Parse("2024-09-09T10:53:00"),
   //             ar_time = DateTime.Parse("2024-09-09T12:53:00"),
   //             status = 1,
   //             note = "Note for segment",
   //             order = 1,
   //             previousSegmentId = null
   //         },
   //         new FlightSegmentViewModel
   //         {
   //             air_id = 2,
   //             route_id = 2,
   //             de_time = DateTime.Parse("2024-09-08T11:00:00"),
   //             ar_time = DateTime.Parse("2024-09-08T13:00:00"),
   //             status = 1,
   //             note = "Another segment",
   //             order = 2,
   //             previousSegmentId = null
   //         },
   //     };
   //
   //     return model;
   // }
   //
            
   [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.flight_segment, PermissionCode = AuthorizeAttribute.PermissionCode.Write, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
   public async Task<IActionResult> DoCreate([FromBody] List<FlightSegmentViewModel> model)
   {
       if (model == null || !model.Any())
       {
           return BadRequest("Model not null.");
       }
       try
       {
           var aircraftsTasks = model.Select(m => aircrarfService.FindById(m.air_id)).ToList();
           var routesTasks = model.Select(m => routesService.FindById(m.route_id)).ToList();
           
           var aircrafts = await Task.WhenAll(aircraftsTasks);
           var routes = await Task.WhenAll(routesTasks);
        
           for (int i = 0; i < model.Count; i++)
           {
               var segment = model[i];
               var aircraft = aircrafts[i];
               var route = routes[i];
               var departureAirportsTasks = await airportService.FindById(route.de_a_id);
               var arrivalAirportsTasks =await airportService.FindById(route.ar_a_id);
               if (aircraft == null || route == null)
               {
                   return NotFound($"Aircraft or route not found for segment with air_id: {segment.air_id} and route_id: {segment.route_id}");
               }
            
               segment.SetValue(aircraft.price_per_km, route.distance, aircraft.economySeats, 
                   aircraft.businessseats, aircraft.airline.code,departureAirportsTasks.name, arrivalAirportsTasks.name);
            
           }

           var userId = await GetCurrentId();
           await _service.Insert(model, userId);

           return ShowJsonSuccess(model.First().id);
       }
       catch (Exception e)
       {
           Console.WriteLine(e);
           throw;
       }
   }

    
   [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.flight_segment, PermissionCode = AuthorizeAttribute.PermissionCode.Update, ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
   [HttpPost]
   public async Task<IActionResult> DoEdit(FlightSegmentViewModel model)
   {
       try
       {
           var aircraft = await aircrarfService.FindById(model.air_id);
           var route = await routesService.FindById(model.route_id);
           if (aircraft == null && route == null)
           {
               throw new Exception();
           }
           var userId = await GetCurrentId();
           await _service.Update(model, userId);
           return ShowJsonSuccess();
       }
       catch (Exception e)
       {
           Console.WriteLine(e);
           throw;
       }
   }
            
   [AuthorizeAttribute.ValidateModule(Module = AuthorizeAttribute.DirectoryModuleEnum.flight_segment, PermissionCode = AuthorizeAttribute.PermissionCode.Delete,ViewType = AuthorizeAttribute.ValidateViewTypeEnum.Json)]
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