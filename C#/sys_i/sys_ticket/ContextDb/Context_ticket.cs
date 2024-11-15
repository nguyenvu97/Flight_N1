using Microsoft.EntityFrameworkCore;
using SysAdmin.Models;

namespace sys_ticket;

public class Context_ticket : DbContext
{
    public Context_ticket(DbContextOptions<Context_ticket> options)
        : base(options)
    {
    }
    public virtual DbSet<TicketData> Ticket { get; set; }


    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        
        modelBuilder.Entity<TicketData>()
            .Property(t => t.amountTotal)
            .HasPrecision(18, 2);

    }
}