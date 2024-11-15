using Microsoft.EntityFrameworkCore;

namespace Backend.Data.Helpers;

public static class SqlFunctions
{
    [DbFunction("dbo", "ToNoneUnicode")]
    public static string ToNoneUnicode(string input) => throw new NotSupportedException();
}