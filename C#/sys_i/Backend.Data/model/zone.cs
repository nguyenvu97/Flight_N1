using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Backend.Data.model;
[Table("zone")]
public class zone
{
    [Key]
    public int id { set; get; }
    public string name { set; get; }
    
    [InverseProperty("zone")]
    public virtual ICollection<airport> airports { get; set; } = new List<airport>();  
}