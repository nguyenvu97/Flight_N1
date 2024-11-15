using System.Reflection;
using Microsoft.Extensions.DependencyInjection;

namespace Backend.Service.Helpper;

public static class BuilderExtensions
{
    public static IServiceCollection AddBackendServices( this IServiceCollection services)
    {
        var implNamespace = "Backend.Service.Imp";
        var implementTypes = Assembly.GetExecutingAssembly().GetTypes().Where(x => x.IsClass && x.IsPublic 
            && x.Namespace == implNamespace && x.GetCustomAttributes(typeof(IgnoreIAutoInjectionAttribute), true).Length == 0).ToList();
        foreach (var type in implementTypes)
        {
            var interfaces = type.GetInterfaces();
            foreach (var i in interfaces)
            {
                if (i.Name.StartsWith("I") && i.Name.EndsWith(type.Name))
                {
                    services.AddSingleton(i, type);
                }
            }
        }
        return services;
    }
}

