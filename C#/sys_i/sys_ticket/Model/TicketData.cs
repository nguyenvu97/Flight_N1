#nullable disable
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SysAdmin.Models;

[Table("ticket_data")]
public class TicketData
{
    [Key]
    public int id { get; set; }
    public string orderNo { get; set; }
    public string orderNoCustomer { get; set; }
    public string ticketTypeGo { get; set; }
    public string ticketTypeBack { get; set; } = "Default Not Value";
    public string ticketType { get; set; }
    public string customType { set; get; }
    public decimal amountTotal { set; get; }
    public string fullName { set; get; }
    public string aliases { set; get; }
    public string birthOfDay { set; get; }
    public string email { set; get; }
    public string phone { set; get; }
    public int bag_go { set; get; }
    public int bag_back { set; get; }
    public string seats_go { set; get; }
    public string seats_go_child { set; get; }
    public string seats_back { set; get; }
    public string seats_back_child { set; get; }
    // public int idCustomer { get; set; }
    //
    // [ForeignKey("idCustomer")]  
    // [InverseProperty("customer_ticket_data")]
    // public virtual CustomerData customer { get; set; }
}