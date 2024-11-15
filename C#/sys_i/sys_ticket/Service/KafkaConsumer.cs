using System.Collections.Concurrent;
using Confluent.Kafka;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using SysAdmin.Models;
using System.Threading.Tasks;
using Microsoft.Extensions.Hosting;
using System.Linq;
using System.Threading;
using System;

namespace sys_ticket.Service
{
    public class KafkaConsumerService : BackgroundService
    {
        private readonly IDbContextFactory<Context_ticket> _dbContextFactory;
        private readonly string _bootstrapServers = "localhost:9092";  
        private readonly string _topic = "sys_ticket_booking"; // Ensure this is valid
        private readonly string _groupId = "order_group";            
        private readonly ConcurrentQueue<TicketDto> _orderQueue = null;  
        private static Random _random = new Random();              

        public KafkaConsumerService(IDbContextFactory<Context_ticket> dbContextFactory)
        {
            _dbContextFactory = dbContextFactory;
            _orderQueue = new ConcurrentQueue<TicketDto>();
        }
        
        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            var config = new ConsumerConfig
            {
                BootstrapServers = _bootstrapServers,
                GroupId = _groupId,
                AutoOffsetReset = AutoOffsetReset.Earliest
            };

            try
            {
                using var consumer = new ConsumerBuilder<string, string>(config).Build();
                if (consumer == null)
                {
                    throw new Exception("Kafka consumer could not be created.");
                }

                consumer.Subscribe(_topic);
                
                while (!stoppingToken.IsCancellationRequested)
                {
                    try
                    {
                        // Consume with a timeout of 10 seconds
                        var consumeResult = consumer.Consume(TimeSpan.FromSeconds(10));

                        if (consumeResult?.Message == null)
                        {
                            Console.WriteLine("No new messages within the last 10 seconds.");
                            continue;  
                        }

                        // Processing the message
                        if (string.IsNullOrEmpty(consumeResult.Message.Value))
                        {
                            Console.WriteLine("Received an empty or null message.");
                            continue;
                        }

                        TicketDto ticket = JsonConvert.DeserializeObject<TicketDto>(consumeResult.Message.Value);

                        if (ticket == null)
                        {
                            Console.WriteLine("Failed to deserialize message to TicketDto.");
                            continue;
                        }

                        _orderQueue.Enqueue(ticket);
                        await ProcessOrdersAsync();
                    }
                    catch (ConsumeException e)
                    {
                        // Handle errors that occur during consumption
                        Console.WriteLine($"ConsumeException occurred: {e.Error.Reason}");
                    }
                    catch (Exception e)
                    {
                        // Catch unexpected errors
                        Console.WriteLine($"Unexpected error: {e.Message}");
                    }
                }
            }
            catch (OperationCanceledException)
            {
                // Handle cancellation gracefully
                Console.WriteLine("Cancellation requested. Closing consumer.");
            }
            catch (Exception ex)
            {
                // Global error handling for Kafka consumer setup or connection issues
                Console.WriteLine($"Error setting up Kafka consumer: {ex.Message}");
            }
        }

        private async Task ProcessOrdersAsync()
        {
            while (_orderQueue.TryDequeue(out var ticket))
            {
                try
                {
                    if (ticket == null || !IsValidTicket(ticket))
                    {
                        Console.WriteLine("Ticket ignored due to validation failure.");
                        continue; 
                    }

                    await SaveOrderToFileAsync(ticket); 
                }
                catch (Exception ex)
                {
                    // Handle errors during processing individual tickets
                    Console.WriteLine($"Error processing ticket: {ex.Message}");
                }
            }
        }
        
        private bool IsValidTicket(TicketDto ticket)
        { 
            return ticket != null && !string.IsNullOrEmpty(ticket.orderNo) && ticket.customers != null && ticket.customers.Any();
        }
        
        private async Task SaveOrderToFileAsync(TicketDto ticket)
        {
            try
            {
                using var context = await _dbContextFactory.CreateDbContextAsync();
                using var transaction = await context.Database.BeginTransactionAsync();

                // Use a semaphore to avoid concurrent access issues when writing to the DB
                var semaphore = new SemaphoreSlim(1, 1);
                await semaphore.WaitAsync();  // Acquire lock

                try
                {
                    if (ticket.customers != null)
                    {
                        var tasks = ticket.customers.Select(async c =>
                        {
                            var tiket = new TicketData
                            {
                                orderNo = ticket.orderNo,
                                orderNoCustomer = GenerateCustomerCodeWithDatePrefix(),  
                                ticketTypeGo = ticket.ticketTypeGo,
                                ticketTypeBack = ticket.ticketTypeBack ?? "Not value",
                                ticketType = ticket.ticketType,
                                customType = c.customType,
                                amountTotal = c.amountTotal,
                                fullName = c.fullName,
                                aliases = c.aliases,
                                birthOfDay = c.birthOfDay,
                                email = c.email,
                                phone = c.phone,
                                bag_go = c.bag_go,
                                bag_back = c.bag_back,
                                seats_go = JsonConvert.SerializeObject(c.seats_go),  
                                seats_back = JsonConvert.SerializeObject(c.seats_back),
                                seats_go_child = JsonConvert.SerializeObject(c.seats_go_child),
                                seats_back_child = JsonConvert.SerializeObject(c.seats_back_child),
                            };

                            await context.Ticket.AddAsync(tiket);
                        }).ToList();

                        // Wait for all tasks to complete
                        await Task.WhenAll(tasks);  
                    }
                }
                finally
                {
                    semaphore.Release();  // Always release the lock
                }
                
                await context.SaveChangesAsync();
                await transaction.CommitAsync();
            }
            catch (Exception ex)
            {
                // Handle errors during DB operation
                Console.WriteLine($"Error saving order to database: {ex.Message}");  
            }
        }
        
        private string GenerateCustomerCodeWithDatePrefix()
        {
            var datePrefix = DateTime.Now.ToString("yyyyMMdd"); 
            var randomNumber = _random.Next(1000, 9999);
            return datePrefix + "-" + randomNumber;
        }
    }
}
