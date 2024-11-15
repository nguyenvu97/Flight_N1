﻿// <auto-generated />
using System;
using Backend.Data.Db;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace Backend.Data.Migrations
{
    [DbContext(typeof(Context))]
    partial class ContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "8.0.7")
                .HasAnnotation("Relational:MaxIdentifierLength", 64);

            MySqlModelBuilderExtensions.AutoIncrementColumns(modelBuilder);

            modelBuilder.Entity("Backend.Data.model.aircarf", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("id"));

                    b.Property<int>("airline_id")
                        .HasColumnType("int");

                    b.Property<int>("businessseats")
                        .HasColumnType("int")
                        .HasColumnName("businessseats");

                    b.Property<string>("code")
                        .IsRequired()
                        .HasMaxLength(250)
                        .HasColumnType("varchar(250)");

                    b.Property<int>("economySeats")
                        .HasColumnType("int")
                        .HasColumnName("economy_seats");

                    b.Property<decimal>("price_per_km")
                        .HasColumnType("decimal(65,30)");

                    b.Property<int>("status")
                        .HasColumnType("int");

                    b.Property<int?>("totalSeats")
                        .HasColumnType("int")
                        .HasColumnName("total_seats");

                    b.Property<string>("type")
                        .IsRequired()
                        .HasMaxLength(250)
                        .HasColumnType("varchar(250)");

                    b.HasKey("id");

                    b.HasIndex("airline_id");

                    b.ToTable("aircarf");
                });

            modelBuilder.Entity("Backend.Data.model.airline", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("id"));

                    b.Property<string>("code")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("varchar(50)");

                    b.Property<string>("name")
                        .IsRequired()
                        .HasMaxLength(250)
                        .HasColumnType("varchar(250)");

                    b.Property<string>("note")
                        .HasColumnType("longtext");

                    b.HasKey("id");

                    b.ToTable("airline");
                });

            modelBuilder.Entity("Backend.Data.model.airport", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("id"));

                    b.Property<string>("code")
                        .IsRequired()
                        .HasMaxLength(250)
                        .HasColumnType("varchar(250)");

                    b.Property<string>("name")
                        .IsRequired()
                        .HasMaxLength(250)
                        .HasColumnType("varchar(250)");

                    b.Property<int>("zone_id")
                        .HasColumnType("int");

                    b.HasKey("id");

                    b.HasIndex("zone_id");

                    b.ToTable("airport");
                });

            modelBuilder.Entity("Backend.Data.model.flight_segment", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("id"));

                    b.Property<int>("air_id")
                        .HasColumnType("int");

                    b.Property<DateTime>("ar_time")
                        .HasColumnType("datetime(6)");

                    b.Property<decimal>("base_price")
                        .HasColumnType("decimal(65,30)");

                    b.Property<string>("code")
                        .HasColumnType("longtext");

                    b.Property<DateTime>("de_time")
                        .HasColumnType("datetime(6)");

                    b.Property<string>("fromCity")
                        .HasColumnType("longtext")
                        .HasColumnName("from_city");

                    b.Property<string>("note")
                        .HasColumnType("longtext");

                    b.Property<int?>("previousSegmentId")
                        .HasColumnType("int")
                        .HasColumnName("previous_segment_id");

                    b.Property<int?>("r_bseats")
                        .HasColumnType("int");

                    b.Property<int?>("r_eseats")
                        .HasColumnType("int");

                    b.Property<int>("route_id")
                        .HasColumnType("int");

                    b.Property<int>("status")
                        .HasColumnType("int");

                    b.Property<string>("toCity")
                        .HasColumnType("longtext")
                        .HasColumnName("to_city");

                    b.HasKey("id");

                    b.HasIndex(new[] { "air_id" }, "Idx_air_id");

                    b.HasIndex(new[] { "previousSegmentId" }, "Idx_previousSegment_id");

                    b.HasIndex(new[] { "route_id" }, "Idx_route_id");

                    b.ToTable("flight_segment");
                });

            modelBuilder.Entity("Backend.Data.model.menu", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("id"));

                    b.Property<string>("action")
                        .HasMaxLength(50)
                        .HasColumnType("varchar(50)");

                    b.Property<string>("class_name")
                        .HasMaxLength(45)
                        .HasColumnType("varchar(45)");

                    b.Property<string>("controller")
                        .HasColumnType("longtext");

                    b.Property<int>("level")
                        .HasColumnType("int");

                    b.Property<string>("name")
                        .IsRequired()
                        .HasMaxLength(250)
                        .HasColumnType("varchar(250)");

                    b.Property<int?>("parent_id")
                        .HasColumnType("int");

                    b.Property<int>("priority")
                        .HasColumnType("int");

                    b.Property<string>("url")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("varchar(50)");

                    b.HasKey("id");

                    b.HasIndex(new[] { "url" }, "idx_url");

                    b.HasIndex(new[] { "parent_id" }, "menu_parent");

                    b.ToTable("menu");
                });

            modelBuilder.Entity("Backend.Data.model.routes", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("id"));

                    b.Property<int>("ar_a_id")
                        .HasColumnType("int");

                    b.Property<int>("de_a_id")
                        .HasColumnType("int");

                    b.Property<int>("distance")
                        .HasColumnType("int");

                    b.Property<string>("note")
                        .HasColumnType("longtext");

                    b.Property<string>("search")
                        .HasColumnType("longtext");

                    b.Property<int>("status")
                        .HasColumnType("int");

                    b.HasKey("id");

                    b.HasIndex(new[] { "ar_a_id" }, "Idx_ar_a");

                    b.HasIndex(new[] { "de_a_id" }, "Idx_de_a");

                    b.ToTable("routes");
                });

            modelBuilder.Entity("Backend.Data.model.transactionLog", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("id"));

                    b.Property<string>("action")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<DateTime>("create")
                        .HasColumnType("datetime(6)");

                    b.Property<string>("json_data")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<int>("record_id")
                        .HasColumnType("int");

                    b.Property<string>("table")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<long>("user_id")
                        .HasColumnType("bigint");

                    b.HasKey("id");

                    b.ToTable("transaction_log");
                });

            modelBuilder.Entity("Backend.Data.model.zone", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("id"));

                    b.Property<string>("name")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("id");

                    b.ToTable("zone");
                });

            modelBuilder.Entity("Backend.Data.model.aircarf", b =>
                {
                    b.HasOne("Backend.Data.model.airline", "airline")
                        .WithMany("aircarfs")
                        .HasForeignKey("airline_id")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("airline");
                });

            modelBuilder.Entity("Backend.Data.model.airport", b =>
                {
                    b.HasOne("Backend.Data.model.zone", "zone")
                        .WithMany("airports")
                        .HasForeignKey("zone_id")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("zone");
                });

            modelBuilder.Entity("Backend.Data.model.flight_segment", b =>
                {
                    b.HasOne("Backend.Data.model.aircarf", "aircarf")
                        .WithMany("flight_segment")
                        .HasForeignKey("air_id")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.HasOne("Backend.Data.model.flight_segment", "previousSegment")
                        .WithMany("subsequentSegments")
                        .HasForeignKey("previousSegmentId")
                        .OnDelete(DeleteBehavior.Restrict);

                    b.HasOne("Backend.Data.model.routes", "route")
                        .WithMany("flight_segment")
                        .HasForeignKey("route_id")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("aircarf");

                    b.Navigation("previousSegment");

                    b.Navigation("route");
                });

            modelBuilder.Entity("Backend.Data.model.menu", b =>
                {
                    b.HasOne("Backend.Data.model.menu", "parent")
                        .WithMany("children")
                        .HasForeignKey("parent_id")
                        .OnDelete(DeleteBehavior.Restrict);

                    b.Navigation("parent");
                });

            modelBuilder.Entity("Backend.Data.model.routes", b =>
                {
                    b.HasOne("Backend.Data.model.airport", "ar_port")
                        .WithMany("ar_port")
                        .HasForeignKey("ar_a_id")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.HasOne("Backend.Data.model.airport", "de_port")
                        .WithMany("de_port")
                        .HasForeignKey("de_a_id")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("ar_port");

                    b.Navigation("de_port");
                });

            modelBuilder.Entity("Backend.Data.model.aircarf", b =>
                {
                    b.Navigation("flight_segment");
                });

            modelBuilder.Entity("Backend.Data.model.airline", b =>
                {
                    b.Navigation("aircarfs");
                });

            modelBuilder.Entity("Backend.Data.model.airport", b =>
                {
                    b.Navigation("ar_port");

                    b.Navigation("de_port");
                });

            modelBuilder.Entity("Backend.Data.model.flight_segment", b =>
                {
                    b.Navigation("subsequentSegments");
                });

            modelBuilder.Entity("Backend.Data.model.menu", b =>
                {
                    b.Navigation("children");
                });

            modelBuilder.Entity("Backend.Data.model.routes", b =>
                {
                    b.Navigation("flight_segment");
                });

            modelBuilder.Entity("Backend.Data.model.zone", b =>
                {
                    b.Navigation("airports");
                });
#pragma warning restore 612, 618
        }
    }
}
