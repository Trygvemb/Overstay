using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Overstay.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class databaseseedUpdate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "DomainUsers",
                keyColumn: "Id",
                keyValue: new Guid("00000000-1000-0000-0000-000000000002"));

            migrationBuilder.DeleteData(
                schema: "identity",
                table: "UserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { new Guid("00000000-1000-0000-0000-000000000004"), new Guid("00000000-1000-0000-0000-000000000002") });

            migrationBuilder.DeleteData(
                schema: "identity",
                table: "Roles",
                keyColumn: "Id",
                keyValue: new Guid("00000000-1000-0000-0000-000000000004"));

            migrationBuilder.DeleteData(
                schema: "identity",
                table: "Users",
                keyColumn: "Id",
                keyValue: new Guid("00000000-1000-0000-0000-000000000002"));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                schema: "identity",
                table: "Roles",
                columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[] { new Guid("00000000-1000-0000-0000-000000000004"), "00000000-0000-0000-0000-000000000002", "User", "USER" });

            migrationBuilder.InsertData(
                schema: "identity",
                table: "Users",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Email", "EmailConfirmed", "LockoutEnabled", "LockoutEnd", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[] { new Guid("00000000-1000-0000-0000-000000000002"), 0, "USER-CONCURRENCY-STAMP", "user@example.com", true, false, null, "USER@EXAMPLE.COM", "USER@EXAMPLE.COM", "AQAAAAIAAYagAAAAEKK+8C5hcOKF5+HGekX1xHVdO/X8Wm1jlTeCMJLOhst9B4t1xUQZlniUiMCrzG5IXg==", null, false, "USER-SECURITY-STAMP", false, "user@example.com" });

            migrationBuilder.InsertData(
                table: "DomainUsers",
                columns: new[] { "Id", "CountryId", "CreatedAt" },
                values: new object[] { new Guid("00000000-1000-0000-0000-000000000002"), new Guid("00000000-0000-0000-0000-000000000184"), new DateTime(2023, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc) });

            migrationBuilder.InsertData(
                schema: "identity",
                table: "UserRoles",
                columns: new[] { "RoleId", "UserId" },
                values: new object[] { new Guid("00000000-1000-0000-0000-000000000004"), new Guid("00000000-1000-0000-0000-000000000002") });
        }
    }
}
