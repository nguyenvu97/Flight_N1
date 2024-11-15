// using Backend.Data.model;
// using Backend.Service.View;
//
// namespace Backend.Service.ViewModel;
//
// public class FlightViewModel: flight
// {
//     public void BeforeSave(FlightViewModel model)
//     {
//         if (model == null)
//         {
//             throw new ArgumentNullException(nameof(model));
//         }
//     }
// }
//
// public class FlightResponse
// {
//     public List<FlightViewModel> Items { get; set; } = [];
//     public int total { get; set; }
// }
//
// public class FlightRequest : DefaultPagingRequest
// {
//     public string key { set; get; }
//     // public string? formDate {set; get;}
//     // public string? toDate {set; get;}
//     public int De_Id { get; set; }
// }
//
// public class FlightPagingResponse
// {
//     public FlightResponse PagingResponse { get; set; }
//     public FlightRequest PagingModel { get; set; }
//
//     public void Binding(FlightResponse pagingResponse)
//     {
//         PagingResponse = pagingResponse;
//         PagingModel.total = pagingResponse.total;
//     }
// }