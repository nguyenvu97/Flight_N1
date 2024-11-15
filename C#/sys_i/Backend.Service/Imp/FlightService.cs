// using Backend.Data.Db;
// using Backend.Data.Helpers;
// using Backend.Data.model;
// using Backend.Service.Helpper;
// using Backend.Service.Interface;
// using Backend.Service.ViewModel;
// using Microsoft.EntityFrameworkCore;
// using SysAdmin.Common;
//
// namespace Backend.Service.Imp;
//
// public class FlightService(IDbContextFactory<Context> _dbContextFactory):IFlightService
// {
//     public async Task Delete(int id,  long userId)
//     {
//         using var context = await _dbContextFactory.CreateDbContextAsync();
//         using var transaction = await context.Database.BeginTransactionAsync();
//         {
//             try
//             {
//                 var entity = await context.FindByIdAsync<flight>(id);
//                 await context.QuickDeleteAsync(entity!, userId);
//                 await transaction.CommitAsync();
//             }
//             catch (Exception e)
//             {
//                 await transaction.RollbackAsync();
//                 Console.WriteLine(e);
//                 throw;
//             }
//         }
//     }
//
//     public async Task<FlightViewModel?> FindById(int id)
//     {
//         using var context = await _dbContextFactory.CreateDbContextAsync();
//         var result = context.Flights
//             .FirstOrDefault(c => c.id == id);
//         return result?.ToModel<FlightViewModel, flight>();
//     }
//
//     public async Task Insert(FlightViewModel model,  long userId)
//     {
//         
//         model.BeforeSave(model);
//
//         using var context = await _dbContextFactory.CreateDbContextAsync();
//         using var transaction = await context.Database.BeginTransactionAsync();
//         {
//             try
//             {
//                 
//                 var entity = model.ToModel<flight, FlightViewModel>();
//                 await context.QuickInsertAsync(entity, userId);
//                 await transaction.CommitAsync();
//             }
//             catch (Exception e)
//             {
//                 Console.WriteLine(e);
//                 throw;
//             }
//         }
//     }
//
//     public async Task Update(FlightViewModel model, long userId)
//     {
//         model.BeforeSave(model);
//         
//         using var context = await _dbContextFactory.CreateDbContextAsync();
//         using var transaction = await context.Database.BeginTransactionAsync();
//         {
//             try
//             {
//                 var entity = model.ToModel<flight, FlightViewModel>();
//                 await context.QuickUpdateAsync(entity, userId);
//                 await transaction.CommitAsync();
//             }
//             catch (Exception)
//             {
//                 await transaction.RollbackAsync();
//                 throw;
//             }
//         }
//     }
//
//     public async Task<FlightResponse> Paging(FlightRequest request)
//     {
//         using var context = await _dbContextFactory.CreateDbContextAsync();
//         var query = context.Flights.AsEnumerable();
//
//         if (request.De_Id > 0)
//         {
//             query = query.Where(x => x.de_port_id == request.De_Id);
//         }
//
//         var total = query.Count();
//         var items = query.Skip((request.Idx - 1) * request.Size)
//             .Take(request.Size).ToList();
//
//         var response = new FlightResponse()
//         {
//             total = total,
//             Items = items.ToModels<FlightViewModel, flight>()
//         };
//         return response;
//     }
// }