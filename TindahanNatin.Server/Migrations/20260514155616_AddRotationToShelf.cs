using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TindahanNatin.Server.Migrations
{
    /// <inheritdoc />
    public partial class AddRotationToShelf : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<double>(
                name: "Rotation",
                table: "Shelves",
                type: "double precision",
                nullable: false,
                defaultValue: 0.0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Rotation",
                table: "Shelves");
        }
    }
}
