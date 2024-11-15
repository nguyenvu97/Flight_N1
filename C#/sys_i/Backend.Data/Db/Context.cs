using Microsoft.EntityFrameworkCore;
using Backend.Data.model;
using Backend.Data.model.Enum;

namespace Backend.Data.Db
{
    public class Context : DbContext
    {
        public Context(DbContextOptions<Context> options)
            : base(options)
        {
        }

        public virtual DbSet<aircarf> Aircarfs { get; set; }
        public virtual DbSet<airport> Airports { get; set; }
        // public virtual DbSet<flight> Flights { get; set; }
        public virtual DbSet<flight_segment> FlightSegments { get; set; }
        public virtual DbSet<routes> Routes { get; set; }
        public virtual DbSet<airline> Airlines { get; set; }
        public virtual DbSet<menu> Menus { get; set; }
        public virtual DbSet<transactionLog> TransactionLogs { get; set; }
        public virtual DbSet<zone> Zones { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

       

            //  airport - routes 
            modelBuilder.Entity<routes>() //san bay di
                .HasOne(r => r.de_port)                
                .WithMany(a => a.de_port)        
                .HasForeignKey(r => r.de_a_id)        
                .OnDelete(DeleteBehavior.Restrict);   

            //  airport - routes 
            modelBuilder.Entity<routes>()//// san bay den
                .HasOne(r => r.ar_port)               
                .WithMany(a => a.ar_port)            
                .HasForeignKey(r => r.ar_a_id)         
                .OnDelete(DeleteBehavior.Restrict);    
            
            // airline - aircarf (n - 1)
            modelBuilder.Entity<airline>()
                .HasMany(a => a.aircarfs)
                .WithOne(a => a.airline)
                .HasForeignKey(f => f.airline_id)
                .OnDelete(DeleteBehavior.Restrict);

            // // flight -airport (1 - n)
            // modelBuilder.Entity<flight>() //san bay di
            //     .HasOne(f => f.airport_de)        
            //     .WithMany(a => a.departing)       
            //     .HasForeignKey(f => f.de_port_id) 
            //     .OnDelete(DeleteBehavior.Restrict); 
            //
            //
            // modelBuilder.Entity<flight>()// san bay den
            //     .HasOne(f => f.airport_ar)        
            //     .WithMany(a => a.arriving)        
            //     .HasForeignKey(f => f.ar_port_id) 
            //     .OnDelete(DeleteBehavior.Restrict); 

            // flight_segment - aircarf
            modelBuilder.Entity<flight_segment>()
                .HasOne(f => f.aircarf)
                .WithMany(a => a.flight_segment)
                .HasForeignKey(f => f.air_id)
                .OnDelete(DeleteBehavior.Restrict); 
            
            // flight_segment - routes
            modelBuilder.Entity<flight_segment>()
                .HasOne(f => f.route)
                .WithMany(r => r.flight_segment)
                .HasForeignKey(f => f.route_id)
                .OnDelete(DeleteBehavior.Restrict); 
            
            // menu - menu (1 - n)
            modelBuilder.Entity<menu>(entity =>
            {
                entity.Property(e => e.parent_id)
                    .IsRequired(false);
                
                entity.HasOne(e => e.parent)
                    .WithMany(e => e.children)
                    .HasForeignKey(e => e.parent_id)
                    .OnDelete(DeleteBehavior.Restrict); 
            });
            
            // zone - airport (1 - n)
            modelBuilder.Entity<zone>()
                .HasMany(z => z.airports)
                .WithOne(a => a.zone)
                .HasForeignKey(a => a.zone_id)
                .OnDelete(DeleteBehavior.Restrict); 
            
            //Flight_segment
            modelBuilder.Entity<flight_segment>()
                .HasOne(fs => fs.previousSegment)
                .WithMany(ps => ps.subsequentSegments)
                .HasForeignKey(fs => fs.previousSegmentId)
                .OnDelete(DeleteBehavior.Restrict);
        }



        public static string RemoveDiacritics(string text)
        {
            throw new NotSupportedException();
        }
    }
}
