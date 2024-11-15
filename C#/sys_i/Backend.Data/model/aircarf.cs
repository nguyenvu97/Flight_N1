// bỏ qua null (#nullable disable)
#nullable disable
using System.ComponentModel.DataAnnotations;

using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace Backend.Data.model;

[Table("aircarf")]
public class aircarf
{
    [Key]
    public int id { get; set; }

    [Required]
    [StringLength(250)]
    public string type { get; set; }

    [Required]
    [StringLength(250)]
    public string code { get; set; }

    [Column("total_seats")]
    public int? totalSeats { get; set; }
    [Column("economy_seats")]
    public int economySeats { get; set; }
    [Column("businessseats")]
    public int businessseats { get; set; }
    //VND
    public decimal price_per_km { get; set; }
    public int status { get; set; }
    
    public int airline_id { get; set; }
    
    [ForeignKey("airline_id")]
    [InverseProperty("aircarfs")]
    [JsonIgnore]
    public virtual airline airline { get; set; }
    
    [InverseProperty("aircarf")]
    [JsonIgnore]
    public virtual ICollection<flight_segment> flight_segment { get; set; } = new List<flight_segment>();
}
