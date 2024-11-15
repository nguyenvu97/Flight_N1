using System.Runtime.Serialization;

namespace Backend.Data.model.Enum;

public enum actionType
{
    [EnumMember(Value = "INSERT")]
    Insert,

    [EnumMember(Value = "UPDATE")]
    Update,

    [EnumMember(Value = "DELETE")]
    Delete   
}