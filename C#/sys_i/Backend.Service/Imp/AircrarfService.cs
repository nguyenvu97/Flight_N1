using System.Linq.Expressions;
using Backend.Data.Db;
using Backend.Data.Helpers;
using Backend.Data.model;
using Backend.Service.Helpper;
using Backend.Service.Interface;
using Backend.Service.ViewModel;
using Microsoft.EntityFrameworkCore;
using SysAdmin.Common;

namespace Backend.Service.Imp;

public class AircrarfService(IDbContextFactory<Context> _dbContextFactory): IAircrarfService
{
    public async Task<List<AircrarfViewModel>> SearchByKey(string key)
    {
        var safeKey = key.ToSafelyText().ToLower();
        using var context = await _dbContextFactory.CreateDbContextAsync();
        var results = context.Aircarfs.AsNoTracking().Where(x =>x.type.Contains(safeKey)).ToList();
        return results.ToModels<AircrarfViewModel, aircarf>();
    }
    public async Task Delete(int id,  long userId)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                var entity = await context.FindByIdAsync<aircarf>(id);
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

    public async Task<AircrarfViewModel?> FindById(int id)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        var result = await context.Aircarfs
        .Include(l => l.airline)
        .Where(c => c.id == id)
        .FirstOrDefaultAsync();
    return result?.ToModel<AircrarfViewModel, aircarf>();
    }

    public async Task Insert(AircrarfViewModel model, long userId)
    {
        model.BeforeSave(model);
        
        if (model == null)
        {
            throw new ArgumentNullException(nameof(model));
        }

        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        try
        {
            var entity = model.ToModel<aircarf, AircrarfViewModel>();
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

    public async Task Update(AircrarfViewModel model, long userId)
    {
        model.BeforeSave(model);
        
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                var entity = model.ToModel<aircarf, AircrarfViewModel>();
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
    
    public async Task<AircrarfResponse> Paging(AircrarfRequest request)
    {
        Expression<Func<aircarf, bool>> predicate = x => x.id > 0;
        
        using var context = await _dbContextFactory.CreateDbContextAsync();
        
        var query = context.Aircarfs.AsEnumerable();
        
        if (!string.IsNullOrEmpty(request.key))
        {
            var key = request.key.ToSafelyText().ToLower();
            query = query.Where(x => x.type.ToNoneUnicode().ToLower().Contains(key));
        }
        
        if (request.airline_id > 0)
        {
            query = query.Where(x => x.airline_id == request.airline_id);
        }
        
        var total = query.Count();
        
        var items = query
            .Skip((request.Idx - 1) * request.Size)
            .Take(request.Size)
            .ToList();
        
        var response = new AircrarfResponse
        {
            total = total,
            Items = items.ToModels<AircrarfViewModel, aircarf>()
        };
        
        return response;
    }
}