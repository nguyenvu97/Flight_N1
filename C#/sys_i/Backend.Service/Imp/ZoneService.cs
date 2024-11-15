using Backend.Data.Db;
using Backend.Data.Helpers;
using Backend.Data.model;
using Backend.Service.Interface;
using Backend.Service.ViewModel;
using Microsoft.EntityFrameworkCore;
using SysAdmin.Common;

namespace Backend.Service.Imp;

public class ZoneService(IDbContextFactory<Context> _dbContextFactory):IZoneService
{
    public async Task Delete(int id, long userId)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                var entity = await context.FindByIdAsync<zone>(id);
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

    public async Task<ZoneViewModel?> FindById(int id)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        var resualt = await context.Zones.FirstOrDefaultAsync(r => r.id == id);
        return resualt?.ToModel<ZoneViewModel, zone>();
    }

    public async Task Insert(ZoneViewModel model, long userId)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                var entity = model.ToModel<zone, ZoneViewModel>();
                await context.QuickInsertAsync(entity, userId);
                await transaction.CommitAsync();
            }
            catch (Exception e)
            {
                await transaction.RollbackAsync();
                Console.WriteLine(e);
                throw;
            }
            
        }
    }

    public async Task<List<ZoneViewModel?>> FindAll()
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        var result = context.Zones.ToList();
        return result?.ToModels<ZoneViewModel, zone>();
    }

    public async Task Update(ZoneViewModel model, long userId)
    {
        model.BeforeSave(model);
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                var entity = model.ToModel<zone, ZoneViewModel>();
                await context.QuickUpdateAsync(entity, userId);
                await transaction.CommitAsync();
            }
            catch (Exception e)
            {
                await transaction.RollbackAsync();
                Console.WriteLine(e);
                throw;
            }
        }
    }
}