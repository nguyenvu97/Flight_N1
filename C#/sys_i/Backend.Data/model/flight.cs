// using System.ComponentModel.DataAnnotations;
// using System.ComponentModel.DataAnnotations.Schema;
// using Microsoft.EntityFrameworkCore;
// // bỏ qua null (#nullable disable)
// #nullable disable
// namespace Backend.Data.model;
//
// [Table("flight")]
// [Index("de_port_id", Name = "Idx_de_port_id")]
// [Index("ar_port_id", Name = "Idx_ar_port_id")]
// public class flight
// {
//     [Key]
//     public int id { get; set; }
//     public int de_port_id { get; set; }
//     public int ar_port_id { set; get; }
//     public DateTime de_time { get; set; }
//     public DateTime ar_time { get; set; }
//     public decimal total_price { get; set; } // gia min trong ngay (k sua ten cot)
//     public int status { get; set; }
//     
//     public string? segment {set; get; } /// Khi tao chuyen add 1 list danh sach chuyen bay trong ngay.
//     public string? note { get; set; }
//
//     [ForeignKey("de_port_id")]
//     [InverseProperty("departing")]
//     public virtual airport airport_de { get; set; }
//     
//     [ForeignKey("ar_port_id")]
//     [InverseProperty("arriving")]
//     public virtual airport airport_ar { get; set; }
//     
// }
