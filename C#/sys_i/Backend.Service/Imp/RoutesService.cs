using System.Runtime.Intrinsics.Arm;
using Backend.Data.Db;
using Backend.Data.Helpers;
using Backend.Data.model;
using Backend.Service.Helpper;
using Backend.Service.Interface;
using Backend.Service.ViewModel;
using Microsoft.EntityFrameworkCore;
using SysAdmin.Common;

namespace Backend.Service.Imp;

public class RoutesService (IDbContextFactory<Context> _dbContextFactory) : IRoutesService
{
    public async Task<List<RoutesViewModel>> SearchByKey(string key)
    {
        var safeKey = key.ToSafelyText().ToLower();
        using var context = await _dbContextFactory.CreateDbContextAsync();
        // var all = context.Routes.AsEnumerable();
        var results = context.Routes.Where(x => x.search.Contains(safeKey)).ToList();
        return results.ToModels<RoutesViewModel, routes>();
    }
    public async Task Delete(int id, long userId)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                var entity = await context.FindByIdAsync<routes>(id);
                await context.QuickDeleteAsync(entity!, userId);
                await transaction.CommitAsync();

            }
            catch (Exception e)
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

    }

    public async Task<RoutesViewModel?> FindById(int id)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        var result = await context.Routes
            .Include(r => r.de_port)
            .Include(r=>r.ar_port)
            .FirstOrDefaultAsync(r => r.id == id);
        return result?.ToModel<RoutesViewModel, routes>();
    }

    public async Task Insert(RoutesViewModel model, long userId)
    {
        model.BeforeSave(model);
        
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                var entity = model.ToModel<routes,RoutesViewModel>();
                await context.QuickInsertAsync(entity,userId);
                await transaction.CommitAsync();
            }
            catch (Exception e)
            {
                await transaction.RollbackAsync();
                throw;
            }
        }
    }

    public async Task Update(RoutesViewModel model, long userId)
    {
        model.BeforeSave(model);
        
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                var entity = model.ToModel<routes, RoutesViewModel>();
                await context.QuickUpdateAsync(entity, userId);
                await transaction.CommitAsync();
            }
            catch (Exception e)
            {
                await transaction.RollbackAsync();
                throw;
            }   
        }
    }

    public async Task<RoutestResponse> Paging(RoutestRequest request)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        var query = context.Routes.Include(r => r.de_port)
            .Include(r => r.ar_port).AsEnumerable();
        foreach (var q in query)
        {
            Console.WriteLine($"{q.distance}+{q.id}");
        }
        if (!string.IsNullOrEmpty(request.key))
        {
            var key = request.key.ToSafelyText().ToLower();
            query = query.Where(x => x.de_port.name.ToNoneUnicode().ToLower().Contains(key));
        }

        var total = query.Count();
        var items = query.Skip((request.Idx - 1) * request.Size)
            .Take(request.Size).ToList();

        var response = new RoutestResponse
        {
            total = total,
            Items = items.ToModels<RoutesViewModel, routes>()
        };
        return response;
    }
}