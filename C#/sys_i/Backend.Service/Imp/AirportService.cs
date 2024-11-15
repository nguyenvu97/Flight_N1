using System.Linq.Expressions;
using Backend.Data.Db;
using Backend.Data.Helpers;
using Backend.Data.model;
using Backend.Service.Helpper;
using Backend.Service.Interface;
using Backend.Service.View;
using Backend.Service.ViewModel;
using Microsoft.EntityFrameworkCore;
using SysAdmin.Common;

namespace Backend.Service.Imp
{
    public class AirportService (IDbContextFactory<Context> _dbContextFactory) : IAirportService
    {

        
        public async Task<List<AirportViewModel>> SearchByKey(string key)
        {
            var safeKey = key.ToSafelyText().ToLower();
            using var context = await _dbContextFactory.CreateDbContextAsync();
            var results = context.Airports.Where(x => x.name.Contains(safeKey)).ToList();
            return results.ToModels<AirportViewModel, airport>();
        }
        public async Task Delete(int id,  long userId)
        {
            using var context = await _dbContextFactory.CreateDbContextAsync();
            using var transaction = await context.Database.BeginTransactionAsync();
            {
                try
                {
                    var entity = await context.FindByIdAsync<airport>(id);
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

        public async Task<AirportViewModel?> FindById(int id)
        {
            using var context = await _dbContextFactory.CreateDbContextAsync();
            var result = context.Airports
                .FirstOrDefault(c => c.id == id);

            return result?.ToModel<AirportViewModel, airport>();
        }

        public async Task Insert(AirportViewModel model,  long userId)
        {
            model.BeforeSave(model);
            
            using var context = await _dbContextFactory.CreateDbContextAsync();
            using var transaction = await context.Database.BeginTransactionAsync();
            try
            {
                var entity = model.ToModel<airport, AirportViewModel>();
                await context.QuickInsertAsync(entity, userId);
                await transaction.CommitAsync();
            }
            catch (Exception)
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public async Task Update(AirportViewModel model,  long userId)
        {
            model.BeforeSave(model);
            
            using var context = await _dbContextFactory.CreateDbContextAsync();
            using var transaction = await context.Database.BeginTransactionAsync();
            {
                try
                {
                    var entity = model.ToModel<airport, AirportViewModel>();
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
        public async Task<AirportResponse> Paging(AirportRequest request)
        {
            using var context = await _dbContextFactory.CreateDbContextAsync();
            
            var query = context.Airports.AsEnumerable(); // Chuyển đổi thành IEnumerable
        
            if (!string.IsNullOrEmpty(request.key))
            {
                var key = request.key.ToSafelyText().ToLower();
                query = query.Where(x => x.name.ToNoneUnicode().ToLower().Contains(key));
            }
        
            var total = query.Count();
        
            var items = query
                .Skip((request.Idx - 1) * request.Size)
                .Take(request.Size)
                .ToList();
        
            var response = new AirportResponse
            {
                total = total,
                Items = items.ToModels<AirportViewModel, airport>()
            };
        
            return response;
        }
        
        // public async Task<AirportResponse> Paging(AirportRequest request)
        // {
        //     Expression<Func<airport, bool>> predicate = x => x.id > 0;
        //
        //     using var context = await _dbContextFactory.CreateDbContextAsync();
        //
        //     // Tìm tất cả dữ liệu
        //     var query = context.Airports.AsEnumerable(); // Chuyển đổi thành IEnumerable
        //
        //     if (!string.IsNullOrEmpty(request.key))
        //     {
        //         var key = request.key.ToSafelyText().ToLower();
        //         query = query.Where(x => x.name.ToNoneUnicode().ToLower().Contains(key));
        //     }
        //
        //     var total = query.Count();
        //
        //     var items = query
        //         .Skip((request.Idx - 1) * request.Size)
        //         .Take(request.Size)
        //         .ToList();
        //
        //     var response = new AirportResponse
        //     {
        //         total = total,
        //         Items = items.ToModels<AirportViewModel, airport>()
        //     };
        //
        //     return response;
        // }
    }
}
