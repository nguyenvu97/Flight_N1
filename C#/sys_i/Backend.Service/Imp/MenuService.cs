

using Backend.Data.Db;
using Backend.Data.Helpers;
using Backend.Data.model;
using Backend.Service.Helpper;
using Backend.Service.Interface;
using Backend.Service.ViewModel;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using SysAdmin.Common;

namespace Backend.Service.Imp;

public class MenuService(IDbContextFactory<Context> _dbContextFactory, IConfiguration _configuration):IMenuService
{
    public async Task<List<MenuViewModel>> SearchByKey(string key)
    {
        var safeKey = key.ToSafelyText().ToLower();
        using var context = await _dbContextFactory.CreateDbContextAsync();
        var results = context.Menus.AsNoTracking().Where(x => x.parent_id == null  && x.name.ToLower().Contains(safeKey)).ToList();
        return results.ToModels<MenuViewModel, menu>();
    }

    public async Task Delete(int id, long userId)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                var entity = await context.FindAsync<menu>(id);
                await context.QuickDeleteAsync(entity!, userId);
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

    public async Task<List<MenuViewModel>> FindAll()
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();

        var menuList = await context.Menus
            .AsNoTracking()
            .OrderBy(x => x.priority)
            .ThenBy(x => x.name)
            .Where(x => x.level > 0 && x.level<3 )
            .ToListAsync();
        
        return BuildMenuHierarchy(menuList.ToModels<MenuViewModel, menu>());
    }
    
    private List<MenuViewModel> BuildMenuHierarchy(List<MenuViewModel> menuList)
    {
        // Tạo dictionary để ánh xạ id của menu tới menu tương ứng
        var menuDictionary = menuList.ToDictionary(m => m.id, m => new MenuViewModel
        {
            id = m.id,
            parent_id = m.parent_id,
            name = m.name,
            url = m.url,
            controller = m.controller,
            action = m.action,
            level = m.level,
            priority = m.priority,
            class_name = m.class_name,
            children = new List<menu>() 
        });

        var rootMenus = new List<MenuViewModel>();

        // Xây dựng cấu trúc phân cấp
        foreach (var menu in menuList.OrderBy(m => m.priority))
        {
            var menuViewModel = menuDictionary[menu.id];

            if (menu.parent_id.HasValue && menuDictionary.ContainsKey(menu.parent_id.Value))
            {
                var parentMenu = menuDictionary[menu.parent_id.Value];
                parentMenu.children.Add(menuViewModel);
            }
            else
            {
                rootMenus.Add(menuViewModel);
            }
        }
        
        // Sắp xếp các menu cha và con theo priority
        rootMenus.ForEach(m => m.children = m.children.OrderBy(c => c.priority).ToList());
        return rootMenus.OrderBy(m => m.priority).ToList();
    }
    
    public async Task<MenuViewModel?> FindById(int id)
    {
        using var context = await _dbContextFactory.CreateDbContextAsync();
        var result = context.Menus.Include(x=> x.parent)
            .FirstOrDefault(c => c.id == id);
            return result?.ToModel<MenuViewModel, menu>();
    }

    public async Task Insert(MenuViewModel model, long userId)
    { 
        model.BindingField(_configuration["Base:BaseUrl"]);
        model.BeforeSave(model);
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                
                var entity = model.ToModel<menu, MenuViewModel>();
                await context.QuickInsertAsync(entity, userId);
                await transaction.CommitAsync();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }
    }

    public async Task Update(MenuViewModel model, long userId)
    {
        model.BindingField(_configuration["Base:BaseUrl"]);
        model.BeforeSave(model);
        using var context = await _dbContextFactory.CreateDbContextAsync();
        using var transaction = await context.Database.BeginTransactionAsync();
        {
            try
            {
                var entity = model.ToModel<menu, MenuViewModel>();
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
}