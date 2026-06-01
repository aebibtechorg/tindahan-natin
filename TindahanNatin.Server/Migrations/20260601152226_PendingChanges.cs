using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TindahanNatin.Server.Migrations
{
    /// <inheritdoc />
    public partial class PendingChanges : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_Announcement",
                table: "Announcement");

            migrationBuilder.RenameTable(
                name: "Announcement",
                newName: "Announcements");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Announcements",
                table: "Announcements",
                column: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_Announcements",
                table: "Announcements");

            migrationBuilder.RenameTable(
                name: "Announcements",
                newName: "Announcement");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Announcement",
                table: "Announcement",
                column: "Id");
        }
    }
}
