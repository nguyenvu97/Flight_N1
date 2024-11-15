#nullable disable
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Backend.Data.model;

[Table("menu")]
[Index("parent_id", Name = "menu_parent")]
[Index("url",Name = "idx_url")]
public partial class menu
{
    [Key]
    public int id { get; set; }

    public int? parent_id { get; set; }
    
    [Required]
    [StringLength(250)]
    public string name { get; set; }

    [Required]
    [StringLength(50)]
    
    public string url { get; set; }
    public string controller { get; set; }

    [StringLength(50)]
    public string action { get; set; }

    public int level { get; set; }
    
    public int priority { get; set; }
    
    [StringLength(45)]
    public string class_name { get; set; }

    [InverseProperty("parent")]
    public virtual ICollection<menu> children { get; set; } = new List<menu>();

    [ForeignKey("parent_id")]
    [InverseProperty("children")]
    public virtual menu parent { get; set; }
}