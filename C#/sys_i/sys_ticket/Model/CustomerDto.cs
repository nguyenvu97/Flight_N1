#nullable disable
namespace SysAdmin.Models;

public class CustomerDto
{
    public string fullName { set; get; }
    public string aliases { set; get; }
    public string birthOfDay { set; get; }
    public string email { set; get; }
    public string phone { set; get; }
    public string customType { set; get; }
    public decimal amountTotal { set; get; }
    public int bag_go { set; get; }
    public int bag_back { set; get; }
    public Dictionary<int, string> seats_go { set; get; }
    public Dictionary<int, string> seats_go_child { set; get; }
    public Dictionary<int, string> seats_back { set; get; }
    public Dictionary<int, string> seats_back_child { set; get; }
}