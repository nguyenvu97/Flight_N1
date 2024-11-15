using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Data.model;
[Table("airline")]
public class airline
{
    [Key]
    public int id { get; set; }

    [Required]
    [StringLength(250)]
    public string name { get; set; }

    [Required]
    [StringLength(50)]
    public string code { get; set; }
    
    public string? note { set; get; }
    
    [InverseProperty("airline")]
    public virtual ICollection<aircarf> aircarfs { get; set; } = new List<aircarf>();
}