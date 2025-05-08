using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Overstay.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class NotificationsFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "DaysBefore",
                table: "Notifications",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<bool>(
                name: "ExpiredNotification",
                table: "Notifications",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "NintyDaysNotification",
                table: "Notifications",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DaysBefore",
                table: "Notifications");

            migrationBuilder.DropColumn(
                name: "ExpiredNotification",
                table: "Notifications");

            migrationBuilder.DropColumn(
                name: "NintyDaysNotification",
                table: "Notifications");
        }
    }
}
