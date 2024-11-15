using Backend.Data.model;
using Backend.Service.View;

namespace Backend.Service.ViewModel;

public class AirlineViewModel: airline
{
    public void BeforeSave(AirlineViewModel model)
    {
        if (model == null)
        {
            throw new ArgumentNullException(nameof(model));
        }
    }
    
}

public class AirlineResponse
{
    public List<AirlineViewModel> Items { get; set; } = [];
    public int total { get; set; }
}

public class AirlineRequest : DefaultPagingRequest
{
    public string key { set; get; }
}

public class AirlinePagingResponse
{
    public AirlineResponse PagingResponse { get; set; }
    public AirlineRequest PagingModel { get; set; }

    public void Binding(AirlineResponse pagingResponse)
    {
        PagingResponse = pagingResponse;
        PagingModel.total = pagingResponse.total;
    }
}