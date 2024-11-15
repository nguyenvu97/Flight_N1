namespace SysAdmin.Models;

public class PaginationModel
{
    public int CurrentPageIndex { get; set; }
    public int CurrentResultCount { get; set; }
    public string FunctionJs { get; set; }
    public int PageSize { get; set; }
    public int TotalItems { get; set; }
}