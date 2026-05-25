using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TindahanNatin.Server.Migrations
{
    /// <inheritdoc />
    public partial class AddSoldByToSale : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "SoldById",
                table: "Sales",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "SoldByName",
                table: "Sales",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "SoldById",
                table: "Sales");

            migrationBuilder.DropColumn(
                name: "SoldByName",
                table: "Sales");
        }
    }
}
