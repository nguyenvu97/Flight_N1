// bỏ qua null (#nullable disable)
#nullable disable
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Backend.Data.model;

[Table("routes")]
[Index("de_a_id", Name = "Idx_de_a")]
[Index("ar_a_id", Name = "Idx_ar_a")]
public class routes
{
    [Key]
    public int id { get; set; }

    public int de_a_id { get; set; }
    public int ar_a_id { get; set; }
    public int distance { get; set; }
    public int status { get; set; }
    public string? search { set; get; }
    
    public string? note { set; get; }
    

    [ForeignKey("de_a_id")]
    [InverseProperty("de_port")]
    public virtual airport de_port { get; set; }

    [ForeignKey("ar_a_id")]
    [InverseProperty("ar_port")]
    public virtual airport ar_port { get; set; }

    [InverseProperty("route")]
    public virtual ICollection<flight_segment> flight_segment { get; set; } = new List<flight_segment>();
}
