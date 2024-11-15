namespace SysAdmin.Models;

public class UserModel
{
    public long id { set; get; }
    public string? name { set; get; }
    public string role { set; get; }
    public string sub { set; get; }
    public long iat { set; get; }
    public long exp { set; get; }
}