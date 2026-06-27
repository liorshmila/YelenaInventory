namespace YelenaInventory.Server.Models;

public class Employee
{
    public int Id { get; set; }

    public int BranchId { get; set; }

    public string Name { get; set; } = "";

    public string PinCode { get; set; } = "";

    public string Role { get; set; } = "Employee";

    public bool IsActive { get; set; } = true;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public Branch Branch { get; set; } = null!;

    public List<InventoryItem> InventoryItems { get; set; } = [];
}