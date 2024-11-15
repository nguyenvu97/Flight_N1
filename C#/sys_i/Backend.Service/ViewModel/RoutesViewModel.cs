using Backend.Data.model;
using Backend.Service.View;

namespace Backend.Service.ViewModel;

public class RoutesViewModel : routes
{
    public void BeforeSave(RoutesViewModel model)
    {
        if (model == null)
        {
            throw new ArgumentNullException(nameof(model));
        }
    }
    public void BindingField(string de, string ar)
    {
            search = $"{de} - {ar}";
    }
}

public class RoutestResponse
{
    public List<RoutesViewModel> Items { get; set; } = [];
    public int total { get; set; }
}

public class RoutestRequest : DefaultPagingRequest
{
    public string key { set; get; }
}

public class RoutesPagingResponse
{
    public RoutestResponse PagingResponse { get; set; }
    public RoutestRequest PagingModel { get; set; }

    public void Binding(RoutestResponse pagingResponse)
    {
        PagingResponse = pagingResponse;
        PagingModel.total = pagingResponse.total;
    }
}