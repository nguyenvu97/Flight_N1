using Backend.Service.View;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Backend.Service.ViewModel;

namespace Backend.Service.Interface
{
    public interface IAirportService
    {
        Task<List<AirportViewModel>> SearchByKey(string key);
        Task Delete(int id,long userId);
        Task<AirportViewModel?> FindById(int id);
        Task Insert(AirportViewModel model,long userId);

        Task Update(AirportViewModel model,long userId);
        Task<AirportResponse> Paging(AirportRequest request);
    }
}
