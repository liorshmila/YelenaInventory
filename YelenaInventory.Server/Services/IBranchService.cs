using YelenaInventory.Server.DTOs;

namespace YelenaInventory.Server.Services;

public interface IBranchService
{
    Task<List<BranchDto>> GetAllAsync();

    Task<BranchDto?> GetByIdAsync(int id);

    Task<BranchDto> CreateAsync(BranchDto dto);
}