using Backend.Data.Db;
using Backend.Data.Helpers;
using Backend.Data.model;
using Backend.Service.Helpper;
using Backend.Service.Interface;
using Backend.Service.ViewModel;
using Microsoft.EntityFrameworkCore;
using SysAdmin.Common;

namespace Backend.Service.Imp;

public class FlightSegmentService(IDbContextFactory<Context> _dbContextFactory) : IFlightSegmentService
{
    public async Task Delete(int id, long userId)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                var entity = await context.FindByIdAsync<flight_segment>(id);
                await context.QuickDeleteAsync(entity!, userId);
                await transaction.CommitAsync();
            }
            catch (Exception)
            {
                await transaction.RollbackAsync();
                throw;
            }
        }
    }

    public async Task<FlightSegmentViewModel?> FindById(int id)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        var result = context.FlightSegments.Include(x => x.route)
            .Include(x =>x.aircarf)
            .FirstOrDefault(x => x.id == id);
        return result?.ToModel<FlightSegmentViewModel, flight_segment>();
    }

    public async Task Insert(List<FlightSegmentViewModel> model, long userId)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        try
        {
            var entities = model.ToModels<flight_segment, FlightSegmentViewModel>();
            
            context.FlightSegments.AddRange(entities);
            await context.SaveChangesAsync();
            
            if (entities.Count > 1)
            {
                var firstSegmentId = entities[0].id;
                for (int i = 1; i < entities.Count; i++)
                {
                    entities[i].previousSegmentId = firstSegmentId;
                }
                context.FlightSegments.UpdateRange(entities);
                await context.SaveChangesAsync();
            }

            await transaction.CommitAsync();
        }
        catch (Exception)
        {
            await transaction.RollbackAsync();
            throw;
        }
    }


    public async Task Update(FlightSegmentViewModel model, long userId)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                var entity = model.ToModel<flight_segment, FlightSegmentViewModel>();
                await context.QuickUpdateAsync(entity, userId);
                await transaction.CommitAsync();
            }
            catch (Exception)
            {
                await transaction.RollbackAsync();
                throw;
            }
        }
    }

    // Segment
    public async Task<FlightSegmentResponse> PagingSegment(FlightSegmentRequest request)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        var query = context.FlightSegments.AsEnumerable();
        
        if (!string.IsNullOrEmpty(request.key))
        {
            var key = request.key.ToSafelyText().ToLower();
            query = query.Where(x => x.code.ToNoneUnicode().ToLower().Contains(key)).ToList(); 
        }
        var total = query.Count();
        var items = query.Skip((request.Idx - 1) * request.Size)
            .Take(request.Size).ToList();
    
        var response = new FlightSegmentResponse()
        {
            total = total,
            Items = items.ToModels<FlightSegmentViewModel, flight_segment>()
        };
        return response;
    }
    
    
    // Flight Trip
    public async Task<List<FlightTripViewModel>> SearchByKey(string key)
    {
        var safeKey = key.ToSafelyText().ToLower();
        var flights = await BuildCompleteFlightsAsync();
        var results = flights.Where(x => x.FromCity.Contains(safeKey)).ToList();
        return results;
    }
    
    
    // public async Task<List<FlightTripViewModel>> BuildCompleteFlightsAsync()
    // {
    //     using var context = await _dbContextFactory.CreateDbContextAsync();
    //     var segments = await context.FlightSegments.ToListAsync();
    //
    //     var flights = new List<FlightTripViewModel>();
    //     var flightMap = new Dictionary<int, FlightTripViewModel>();
    //     var segmentMap = new Dictionary<int, flight_segment>();
    //
    //     // Tạo bản đồ các đoạn chuyến bay
    //     foreach (var segment in segments)
    //     {
    //         segmentMap[segment.id] = segment;
    //     }
    //     
    //     foreach (var segment in segments)
    //     {
    //         if (segment.previousSegmentId == null)
    //         {
    //             var flight = new FlightTripViewModel
    //             {
    //                 TripId = segment.id,
    //                 FromCity = segment.fromCity,
    //                 ToCity = segment.toCity,
    //                 DepartureTime = segment.de_time,
    //                 ArrivalTime = segment.ar_time,
    //                 TotalPrice = segment.base_price,
    //                 Segment = segment.id.ToString(),
    //                 Segments = new List<FlightSegmentViewModel> { segment.ToModel<FlightSegmentViewModel, flight_segment>() } 
    //                 
    //             };
    //
    //             flights.Add(flight);
    //             flightMap[segment.id] = flight;
    //         }
    //         else
    //         {
    //             if (flightMap.TryGetValue(segment.previousSegmentId.Value, out var flight))
    //             {
    //                 flight.ToCity = segment.toCity;
    //                 flight.ArrivalTime = segment.ar_time;
    //                 flight.TotalPrice += segment.base_price;
    //                 flight.Segment += $", {segment.id}";
    //                 flight.Segments.Add(segment.ToModel<FlightSegmentViewModel, flight_segment>() );
    //             }
    //         }
    //     }
    //
    //     return flights;
    // }
    //
    
    public async Task<List<FlightTripViewModel>> BuildCompleteFlightsAsync()
        {
            using var context = await _dbContextFactory.CreateDbContextAsync();
            var segments = await context.FlightSegments.ToListAsync();
    
            var flights = new List<FlightTripViewModel>();
            // var segmentMap = segments.ToDictionary(s => s.id);
            // var addedSegments = new HashSet<int>(); 
            
            foreach (var segment in segments)
            {
                if (segment.previousSegmentId == null)
                {
                    var directFlight = new FlightTripViewModel
                    {
                        TripId = segment.id,
                        FromCity = segment.fromCity,
                        ToCity = segment.toCity,
                        DepartureTime = segment.de_time,
                        ArrivalTime = segment.ar_time,
                        TotalPrice = segment.base_price,
                        Segment = segment.id.ToString(),
                        Segments = new List<FlightSegmentViewModel> { segment.ToModel<FlightSegmentViewModel, flight_segment>() }
                    };
    
                    flights.Add(directFlight); 
    
                    // Kiểm tra các chuyến bay nối chuyến từ chuyến bay thẳng này
                    var connectedSegments = segments.Where(s => s.previousSegmentId == segment.id).ToList();
                    foreach (var connectedSegment in connectedSegments)
                    {
                        var connectedFlight = new FlightTripViewModel
                        {
                            TripId = connectedSegment.id,
                            FromCity = segment.fromCity,
                            ToCity = connectedSegment.toCity,
                            DepartureTime = segment.de_time,
                            ArrivalTime = connectedSegment.ar_time,
                            TotalPrice = segment.base_price + connectedSegment.base_price,
                            Segment = $"{segment.id}, {connectedSegment.id}",
                            Segments = new List<FlightSegmentViewModel>
                            {
                                segment.ToModel<FlightSegmentViewModel, flight_segment>(),
                                connectedSegment.ToModel<FlightSegmentViewModel, flight_segment>()
                            }
                        };
    
                        flights.Add(connectedFlight); 
                    }
                }
            }
    
            return flights;
        }
    
    
    
    public async Task<FlightTripResponse> PagingTrip(FlightTripRequest request)
    {
        var flights = await BuildCompleteFlightsAsync();
        
        
        if (!string.IsNullOrEmpty(request.key))
        {
            var key = request.key.ToSafelyText().ToLower();
            flights = flights.Where(x => x.FromCity.ToNoneUnicode().ToLower().Contains(key)).ToList(); 
        }


        var total = flights.Count;
        var pagedFlights = flights.Skip((request.Idx - 1) * request.Size)
            .Take(request.Size)
            .ToList();

        var response = new FlightTripResponse
        {
            total = total,
            Items = pagedFlights.Select(f => new FlightTripViewModel()
            {
                TripId = f.TripId,
                FromCity = f.FromCity,
                ToCity = f.ToCity,
                DepartureTime = f.DepartureTime,
                ArrivalTime = f.ArrivalTime,
                TotalPrice = f.TotalPrice,
                Segment = f.Segment,
                Segments = f.Segments
            }).ToList()
        };

        return response;
    }
    
    
    
//         public async Task<List<FlightTripViewModel>> BuildCompleteFlightsAsync()
// {
//     using var context = await _dbContextFactory.CreateDbContextAsync();
//     var segments = await context.FlightSegments.ToListAsync();
//
//     var flights = new List<FlightTripViewModel>();
//
//     foreach (var segment in segments)
//     {
//         if (segment.previousSegmentId == null)
//         {
//             // Handle direct flights (single segment)
//             var directFlight = new FlightTripViewModel
//             {
//                 TripId = segment.id,
//                 FromCity = segment.fromCity,
//                 ToCity = segment.toCity,
//                 DepartureTime = segment.de_time,
//                 ArrivalTime = segment.ar_time,
//                 TotalPrice = segment.base_price,
//                 Segment = segment.id.ToString(),
//                 Segments = new List<FlightSegmentViewModel> { segment.ToModel<FlightSegmentViewModel, flight_segment>() }
//             };
//
//             flights.Add(directFlight);
//
//             // Handle connected flights (two segments)
//             var connectedSegments = segments.Where(s => s.previousSegmentId == segment.id).ToList();
//             foreach (var connectedSegment in connectedSegments)
//             {
//                 var connectedFlight = new FlightTripViewModel
//                 {
//                     TripId = segment.id,
//                     FromCity = segment.fromCity,
//                     ToCity = connectedSegment.toCity,
//                     DepartureTime = segment.de_time,
//                     ArrivalTime = connectedSegment.ar_time,
//                     TotalPrice = segment.base_price + connectedSegment.base_price,
//                     Segment = $"{segment.id}, {connectedSegment.id}",
//                     Segments = new List<FlightSegmentViewModel>
//                     {
//                         segment.ToModel<FlightSegmentViewModel, flight_segment>(),
//                         connectedSegment.ToModel<FlightSegmentViewModel, flight_segment>()
//                     }
//                 };
//
//                 flights.Add(connectedFlight);
//
//                 // Handle three connected segments
//                 var connectedSegments1 = segments.Where(s => s.previousSegmentId == connectedSegment.id).ToList();
//                 foreach (var connectedSegment1 in connectedSegments1)
//                 {
//                     var connectedFlight1 = new FlightTripViewModel
//                     {
//                         TripId = segment.id,
//                         FromCity = segment.fromCity,
//                         ToCity = connectedSegment1.toCity,
//                         DepartureTime = segment.de_time,
//                         ArrivalTime = connectedSegment1.ar_time,
//                         TotalPrice = segment.base_price + connectedSegment.base_price + connectedSegment1.base_price,
//                         Segment = $"{segment.id}, {connectedSegment.id}, {connectedSegment1.id}",
//                         Segments = new List<FlightSegmentViewModel>
//                         {
//                             segment.ToModel<FlightSegmentViewModel, flight_segment>(),
//                             connectedSegment.ToModel<FlightSegmentViewModel, flight_segment>(),
//                             connectedSegment1.ToModel<FlightSegmentViewModel, flight_segment>()
//                         }
//                     };
//
//                     flights.Add(connectedFlight1);
//                 }
//             }
//         }
//     }
//
//     return flights;
// }

    
}