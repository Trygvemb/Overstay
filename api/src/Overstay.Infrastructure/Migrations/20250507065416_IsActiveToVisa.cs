using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Overstay.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class IsActiveToVisa : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "DomainUsers",
                keyColumn: "Id",
                keyValue: new Guid("00000000-1000-0000-0000-000000000001"));

            migrationBuilder.DeleteData(
                schema: "identity",
                table: "UserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { new Guid("00000000-1000-0000-0000-000000000003"), new Guid("00000000-1000-0000-0000-000000000001") });

            migrationBuilder.DeleteData(
                schema: "identity",
                table: "UserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { new Guid("00000000-1000-0000-0000-000000000004"), new Guid("00000000-1000-0000-0000-000000000001") });

            migrationBuilder.DeleteData(
                schema: "identity",
                table: "Roles",
                keyColumn: "Id",
                keyValue: new Guid("00000000-1000-0000-0000-000000000003"));

            migrationBuilder.DeleteData(
                schema: "identity",
                table: "Users",
                keyColumn: "Id",
                keyValue: new Guid("00000000-1000-0000-0000-000000000001"));

            migrationBuilder.AddColumn<bool>(
                name: "IsActive",
                table: "Visas",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsActive",
                table: "Visas");

            migrationBuilder.InsertData(
                schema: "identity",
                table: "Roles",
                columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[] { new Guid("00000000-1000-0000-0000-000000000003"), "00000000-0000-0000-0000-000000000001", "Admin", "ADMIN" });

            migrationBuilder.InsertData(
                schema: "identity",
                table: "Users",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Email", "EmailConfirmed", "LockoutEnabled", "LockoutEnd", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[] { new Guid("00000000-1000-0000-0000-000000000001"), 0, "ADMIN-CONCURRENCY-STAMP", "admin@example.com", true, false, null, "ADMIN@EXAMPLE.COM", "ADMIN@EXAMPLE.COM", "AQAAAAIAAYagAAAAENfB6BxN/Z1wQz9vgEiJAL6xxWWlHfgK8JQkZ3XvjLlrqzYb6ASzjOYNkI/6OYvVeA==", null, false, "ADMIN-SECURITY-STAMP", false, "admin@example.com" });

            migrationBuilder.InsertData(
                table: "DomainUsers",
                columns: new[] { "Id", "CountryId", "CreatedAt" },
                values: new object[] { new Guid("00000000-1000-0000-0000-000000000001"), new Guid("00000000-0000-0000-0000-000000000183"), new DateTime(2023, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc) });

            migrationBuilder.InsertData(
                schema: "identity",
                table: "UserRoles",
                columns: new[] { "RoleId", "UserId" },
                values: new object[,]
                {
                    { new Guid("00000000-1000-0000-0000-000000000003"), new Guid("00000000-1000-0000-0000-000000000001") },
                    { new Guid("00000000-1000-0000-0000-000000000004"), new Guid("00000000-1000-0000-0000-000000000001") }
                });
        }
    }
}
