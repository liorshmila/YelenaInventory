using Microsoft.EntityFrameworkCore;
using YelenaInventory.Server.Models;

namespace YelenaInventory.Server.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<Employee> Employees => Set<Employee>();

    public DbSet<Branch> Branches => Set<Branch>();

    public DbSet<InventoryItem> Inventory => Set<InventoryItem>();
}