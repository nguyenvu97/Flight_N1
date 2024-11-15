namespace sys_i.Common
{
    
    public enum ResultCode
    {
        Success,
        Error,
    }
    public class ResponseData
    {
        public string Status { get; set; } = null!;
        public object? Data { get; set; }

        public static ResponseData Error(object? data = null)
        {
            return new ResponseData { Status = ResultCode.Error.ToString(), Data = data };
        }

        public static ResponseData Success(object? data = null)
        {
            return new ResponseData { Status = ResultCode.Success.ToString(), Data = data };
        }
    }
}
