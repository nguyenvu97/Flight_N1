using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Data.model;

[Table("transaction_log")]
public class transactionLog
{
    [Key] 
    public int id { set; get; }
    public long user_id { set; get; }
    public string action { set; get; }
    public string table { set; get; }
    public int record_id { set; get; }
    public string json_data { set; get; }
    public DateTime create { set; get; }

}