namespace Backend.Service.View;

public class DefaultPagingRequest
{
    public string? key { get; set; }
    public int Idx { get; set; } = 1;
    public int Size { get; set; } = 10;
    public int total { get; set; }  
}