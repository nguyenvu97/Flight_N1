using AutoMapper;

namespace SysAdmin.Common;

public static class AutoMapperConfig<T, TF>
{
    private static readonly MapperConfiguration config = new(cfg =>
    {
        cfg.CreateMap<T, TF>().MaxDepth(2);
        cfg.CreateMap<TF, T>().MaxDepth(2);
    });

    public static IMapper GetMapper() => config.CreateMapper();
}
public static class Mapper
{
    public static List<T> ToModels<T, TF>(this List<TF> source)
    {
        var mapper = AutoMapperConfig<T, TF>.GetMapper();
        return source.ConvertAll(x => mapper.Map<T>(x));
    }
    
    public static T ToModel<T, TF>(this TF source)
    {
        var mapper = AutoMapperConfig<T, TF>.GetMapper();
        return mapper.Map<T>(source);
    }
}



