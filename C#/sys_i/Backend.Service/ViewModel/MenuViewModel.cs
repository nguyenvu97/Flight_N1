using Backend.Data.model;

namespace Backend.Service.ViewModel;

public class MenuViewModel : menu
{

    public void BeforeSave(MenuViewModel model)
    {
        if (model.parent_id.HasValue)
        {
            if (model.level != 2)
            {
                throw new ArgumentNullException(nameof(model));
            }
        }
        
        if (model == null || (model.level < 1 || model.level >2) )
        {
            throw new ArgumentNullException(nameof(model));
        }
        
    }

    public void BindingField(string urlBase)
    {
        url = urlBase;
    }
    public string UrlAction
    {
        get
        {
            if (!string.IsNullOrEmpty(url))
                return url;

            var results = "/" + controller;
            if (!string.IsNullOrEmpty(action))
                results += "/" + action;
            return results;
        }
    }
    
    public string DisplayTreeName
    {
        get
        {
            var results = "";
            for (var i = 1; i <= level; i++)
            {
                results += System.Web.HttpUtility.HtmlDecode("&#8212;");
            }
            return results + name;
        }
    }
    
}