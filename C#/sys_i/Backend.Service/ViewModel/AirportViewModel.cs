using Backend.Data.model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Backend.Service.View;

namespace Backend.Service.ViewModel
{
    public class AirportViewModel : airport
    {
        public void BeforeSave(AirportViewModel model)
        {
            if (model == null)
            {
                throw new ArgumentNullException(nameof(model));
            }
        }
    }
    
    public class AirportResponse
    {
        public List<AirportViewModel> Items { get; set; } = [];
        public int total { get; set; }
    }

    public class AirportRequest : DefaultPagingRequest
    {
        public string key { set; get; }
    }

    public class AirportPagingResponse
    {
        public AirportResponse PagingResponse { get; set; }
        public AirportRequest PagingModel { get; set; }

        public void Binding(AirportResponse pagingResponse)
        {
            PagingResponse = pagingResponse;
            PagingModel.total = pagingResponse.total;
        }
    }
}
