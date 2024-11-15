using System.Linq.Expressions;
using Backend.Data.Db;
using Backend.Data.model;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

namespace Backend.Data.Helpers;

public static class ContextEx
{
    public static async Task<T?> FindByIdAsync<T>(this Context context, object id) where T : class
    {
        context.ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;
        return await context.Set<T>().FindAsync(id);
    }
    
    public static async Task<List<T>> FindAllAsync<T>(this Context context, Expression<Func<T, bool>>? predicate = null) where T : class
    {
        context.ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;
        return predicate != null ?
            await context.Set<T>().Where(predicate).ToListAsync() :
            await context.Set<T>().ToListAsync();
    }
    
    public static async Task QuickInsertAsync<T>(this Context context, T model, long userId) where T : class
    {
            await context.Set<T>().AddAsync(model);
            await context.SaveChangesAsync();
            
            await LogActionAsync(context, userId, "INSERT", typeof(T).Name, GetEntityId(model), model);
    }
    
    public static async Task QuickUpdateAsync<T>(this Context context, T model,long userId) where T : class
    {
        context.Set<T>().Update(model);
        await context.SaveChangesAsync();
        
        await LogActionAsync(context, userId, "UPDATE", typeof(T).Name, GetEntityId(model), model);
    }
    
    public static async Task QuickDeleteAsync<T>(this Context context, T model, long userId) where T : class
    {
        context.Set<T>().Remove(model); 
        await context.SaveChangesAsync();
        
        await LogActionAsync(context, userId, "DELETE", typeof(T).Name, GetEntityId(model), model);
    }
    
    private static async Task LogActionAsync(Context context, long userId, string action, string tableName, int recordId, object data)
    {
        var logTransaction = new transactionLog
        {
            user_id = userId,
            action = action, 
            table = tableName,
            record_id = recordId,
            json_data = JsonConvert.SerializeObject(data),
            create = DateTime.Now 
        };

        await context.Set<transactionLog>().AddAsync(logTransaction);
        await context.SaveChangesAsync();
    }

    private static int GetEntityId<T>(T entity)
    {
        var property = entity.GetType().GetProperty("id") ?? throw new Exception("Entity does not have an Id property.");
        return (int)(property.GetValue(entity) ?? throw new Exception("Entity Id is null."));
    }
    
}