using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Backend.Data.model;
[Table("flight_segment")]
[Index("air_id", Name = "Idx_air_id")]
[Index("route_id", Name = "Idx_route_id")]
[Index("previousSegmentId", Name = "Idx_previousSegment_id")]
public class flight_segment
{
    [Key]
    public int id { get; set; }

    public int air_id { get; set; }
    public int route_id { get; set; }
    
    [Column("from_city")]
    public string? fromCity { get; set; }
    
    [Column("to_city")]
    public string? toCity { get; set; }
    public DateTime de_time { get; set; }
    public DateTime ar_time { get; set; }
    public decimal base_price { get; set; }
    public int? r_eseats { get; set; }
    public int? r_bseats { get; set; }
    public int status { get; set; }
    public string? code { get; set; }
    public string? note { get; set; }

    
    [Column("previous_segment_id")]
    public int? previousSegmentId { get; set; }
    
    [ForeignKey("previousSegmentId")]
    [InverseProperty("subsequentSegments")]
    public virtual flight_segment previousSegment { get; set; }

    [InverseProperty("previousSegment")]
    public virtual ICollection<flight_segment> subsequentSegments { get; set; } = new List<flight_segment>();
    
    [ForeignKey("air_id")]
    [InverseProperty("flight_segment")]
    public virtual aircarf aircarf { get; set; }

    [ForeignKey("route_id")]
    [InverseProperty("flight_segment")]
    public virtual routes route { get; set; }
}