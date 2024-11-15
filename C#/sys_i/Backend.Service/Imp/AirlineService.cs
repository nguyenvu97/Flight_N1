using Backend.Data.Db;
using Backend.Data.Helpers;
using Backend.Data.model;
using Backend.Service.Helpper;
using Backend.Service.Interface;
using Backend.Service.ViewModel;
using Microsoft.EntityFrameworkCore;
using SysAdmin.Common;

namespace Backend.Service.Imp;

public class AirlineService(IDbContextFactory<Context> _dbContextFactory) : IAirlineService
{
    
    public async Task<List<AirlineViewModel>> SearchByKey(string key)
    {
        var safeKey = key.ToSafelyText().ToLower();
        using var context = await _dbContextFactory.CreateDbContextAsync();
        var results = context.Airlines.Where(x => x.name.Contains(safeKey)).ToList();
        return results.ToModels<AirlineViewModel, airline>();
    }
    public async Task Delete(int id,  long userId)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                var entity = await context.FindByIdAsync<airline>(id);
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

    public async Task<AirlineViewModel?> FindById(int id)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        var result = context.Airlines.Include(c => c.aircarfs)
            .FirstOrDefault(c => c.id == id);

        return result?.ToModel<AirlineViewModel, airline>();
    }

    public async Task Insert(AirlineViewModel model,  long userId)
    {
        model.BeforeSave(model);
        
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        try
        {
            var entity = model.ToModel<airline, AirlineViewModel>();
            await context.QuickInsertAsync(entity, userId);
            await transaction.CommitAsync();
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            Console.WriteLine(ex.Message);
            throw;
        }
    }

    public async Task<List<AirlineViewModel?>> FindAll()
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        var result = context.Airlines.ToList();
        return result?.ToModels<AirlineViewModel, airline>();
    }

    public async Task Update(AirlineViewModel model,  long userId)
    {
        model.BeforeSave(model);
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                var entity = model.ToModel<airline, AirlineViewModel>();
                await context.QuickUpdateAsync(entity, userId);
                await transaction.CommitAsync();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }
    }

    public async Task<AirlineResponse> Paging(AirlineRequest request)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        
        var query = context.Airlines.AsEnumerable();
        
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
        
        var response = new AirlineResponse()
        {
            total = total,
            Items = items.ToModels<AirlineViewModel, airline>()
        };
        
        return response;
    }
}