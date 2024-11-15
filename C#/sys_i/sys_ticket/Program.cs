using Microsoft.EntityFrameworkCore;
using sys_ticket;
using sys_ticket.Service;

var builder = WebApplication.CreateBuilder(args);
// builder.Services.AddDbContextFactory<Context_ticket>(options =>
//     options.UseSqlServer(builder.Configuration.GetConnectionString("DB"))
// );
builder.Services.AddDbContextFactory<Context_ticket>(options =>
    options.UseMySql(
        builder.Configuration.GetConnectionString("DB"),
        new MySqlServerVersion(new Version(8, 0, 21)) 
    )
);

// Register Kafka Consumer Service as a Scoped service
builder.Services.AddSingleton<KafkaConsumerService>();
// builder.Services.AddScoped<TicketService>();
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull;
    });
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();
var kafkaConsumerService = app.Services.GetRequiredService<KafkaConsumerService>();
Task.Run(() => kafkaConsumerService.StartAsync(CancellationToken.None));
// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// app.UseHttpsRedirection();
app.UseRouting(); 
app.UseEndpoints(endpoints => 
{
    endpoints.MapControllers(); 
});

app.Run();