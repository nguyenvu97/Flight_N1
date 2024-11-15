#nullable disable
namespace SysAdmin.Models;

public class TicketDto
{
    public string id {set;get;}
    public string orderNo{set;get;}
    public string OrderStatus{set;get;}
    public string ticketTypeGo{set;get;}
    public string ticketTypeBack{set;get;}
    private decimal totalTicket{set;get;}
    public string ticketType{set;get;}
    public List<CustomerDto>customers{set;get;} =new List<CustomerDto>();
    public FlightTicketDto flights_go{set;get;}
    public FlightTicketDto flights_back {set;get;}
}