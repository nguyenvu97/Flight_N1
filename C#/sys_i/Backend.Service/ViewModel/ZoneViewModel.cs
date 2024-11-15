using Backend.Data.model;

namespace Backend.Service.ViewModel;

public class ZoneViewModel:zone
{
    public void BeforeSave(ZoneViewModel model)
    {
        if (model == null)
        {
            throw new ArgumentNullException(nameof(model));
        }
    }
}