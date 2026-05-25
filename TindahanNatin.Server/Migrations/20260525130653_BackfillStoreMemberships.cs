using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TindahanNatin.Server.Migrations
{
    /// <inheritdoc />
    public partial class BackfillStoreMemberships : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
                INSERT INTO ""StoreMemberships"" (""Id"", ""StoreId"", ""UserId"", ""Role"", ""CreatedAt"")
                SELECT gen_random_uuid(), ""Id"", ""OwnerId"", 'Owner', NOW()
                FROM ""Stores""
                WHERE ""Id"" NOT IN (SELECT ""StoreId"" FROM ""StoreMemberships"" WHERE ""Role"" = 'Owner');
            ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
