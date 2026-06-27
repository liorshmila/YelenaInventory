namespace YelenaInventory.Server.Models;

public class InventoryItem
{
    public int Id { get; set; }

    public string Barcode { get; set; } = "";

    public int Quantity { get; set; }

    public int EmployeeId { get; set; }

    public int BranchId { get; set; }

    public DateTime CountDate { get; set; }

    public string Note { get; set; } = "";

    public string DeviceId { get; set; } = "";

    public string SyncStatus { get; set; } = "Pending";

    public bool UpdatedToScanner { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

    public Employee Employee { get; set; } = null!;

    public Branch Branch { get; set; } = null!;
}

