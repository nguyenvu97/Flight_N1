namespace Backend.Data.Db.Functions;

public class SqlFunctions
{
    public class Sp
    {
        public const string RemoveDiacritics = "dbo.RemoveDiacritics";
    }
    
    public static string ExecuteFunction(string functionName, params object[] parameters)
    {
        throw new NotSupportedException("This method should not be called directly.");
    }
    
    public static string RemoveDiacritics(string text) =>
        ExecuteFunction("RemoveDiacritics", text);

}