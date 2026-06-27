using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace YelenaInventory.Server.Migrations
{
    /// <inheritdoc />
    public partial class AddRelations : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_Inventory_BranchId",
                table: "Inventory",
                column: "BranchId");

            migrationBuilder.CreateIndex(
                name: "IX_Inventory_EmployeeId",
                table: "Inventory",
                column: "EmployeeId");

            migrationBuilder.CreateIndex(
                name: "IX_Employees_BranchId",
                table: "Employees",
                column: "BranchId");

            migrationBuilder.AddForeignKey(
                name: "FK_Employees_Branches_BranchId",
                table: "Employees",
                column: "BranchId",
                principalTable: "Branches",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Inventory_Branches_BranchId",
                table: "Inventory",
                column: "BranchId",
                principalTable: "Branches",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Inventory_Employees_EmployeeId",
                table: "Inventory",
                column: "EmployeeId",
                principalTable: "Employees",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Employees_Branches_BranchId",
                table: "Employees");

            migrationBuilder.DropForeignKey(
                name: "FK_Inventory_Branches_BranchId",
                table: "Inventory");

            migrationBuilder.DropForeignKey(
                name: "FK_Inventory_Employees_EmployeeId",
                table: "Inventory");

            migrationBuilder.DropIndex(
                name: "IX_Inventory_BranchId",
                table: "Inventory");

            migrationBuilder.DropIndex(
                name: "IX_Inventory_EmployeeId",
                table: "Inventory");

            migrationBuilder.DropIndex(
                name: "IX_Employees_BranchId",
                table: "Employees");
        }
    }
}
