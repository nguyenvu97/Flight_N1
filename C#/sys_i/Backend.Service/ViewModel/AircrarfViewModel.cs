using Backend.Data.model;
using Backend.Service.View;

namespace Backend.Service.ViewModel;

public class AircrarfViewModel: aircarf
{
    public void BeforeSave(AircrarfViewModel model)
    {
        model.totalSeats = model.businessseats + model.economySeats;
        
        if (model == null)
        {
            throw new ArgumentNullException(nameof(model));
        }
    }
}

public class AircrarfResponse
{
    public List<AircrarfViewModel> Items { get; set; } = [];
    public int total { get; set; }
}

public class AircrarfRequest : DefaultPagingRequest
{
    public string key { set; get; }
    public int airline_id { set; get; }
}

public class AircrarfPagingResponse
{
    public AircrarfResponse PagingResponse { get; set; }
    public AircrarfRequest PagingModel { get; set; }

    public void Binding(AircrarfResponse pagingResponse)
    {
        PagingResponse = pagingResponse;
        PagingModel.total = pagingResponse.total;
    }
}