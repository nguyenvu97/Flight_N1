using System.Text;
using System.Text.RegularExpressions;

namespace Backend.Service.Helpper;

public static class StringExtension
{
    public static string ToNoneUnicode(this string str)
    {
        if (string.IsNullOrEmpty(str)) return "";
        var regex = new Regex("\\p{IsCombiningDiacriticalMarks}+");
        string temp = str.Normalize(NormalizationForm.FormD);
        string result = regex.Replace(temp, string.Empty).Replace('\u0111', 'd').Replace('\u0110', 'D').Trim();
        return result;
    }

    
    public static string ToSafelyText(this string str, string? spliter = null)
    {
        if (string.IsNullOrEmpty(str)) return "";
        str = str.ToNoneUnicode();
    
        if (string.IsNullOrEmpty(spliter))
            return Regex.Replace(str, "[^a-zA-Z0-9]+", "", RegexOptions.Compiled).Trim();
    
        var newStr = Regex.Replace(str, "[^a-zA-Z0-9]+", " ", RegexOptions.Compiled);
        newStr = Regex.Replace(newStr, @"\s+", " ", RegexOptions.Compiled).Trim();
        return newStr.Replace(" ", spliter);
    }
}