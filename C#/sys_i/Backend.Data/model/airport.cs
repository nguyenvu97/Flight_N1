using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Data.model;

[Table("airport")]
public class airport
{
    [Key]
    public int id { get; set; }

    [Required]
    [StringLength(250)]
    public string code { get; set; }

    [Required]
    [StringLength(250)]
    public string name { get; set; }
        
    public int zone_id { get; set; }
        
    [ForeignKey("zone_id")]
    [InverseProperty("airports")]
    public virtual zone zone { get; set; }
    
    // [InverseProperty("airport_de")]
    // public virtual ICollection<flight> departing { get; set; } = new List<flight>();
    //
    // [InverseProperty("airport_ar")]
    // public virtual ICollection<flight> arriving { get; set; } = new List<flight>();
        
    [InverseProperty("de_port")]
    public virtual ICollection<routes> de_port { get; set; } = new List<routes>();

    [InverseProperty("ar_port")]
    public virtual ICollection<routes> ar_port { get; set; } = new List<routes>();
}
