using YelenaInventory.Server.Models;

namespace YelenaInventory.Server.Repositories;

public interface IBranchRepository
{
    Task<List<Branch>> GetAllAsync();

    Task<Branch?> GetByIdAsync(int id);

    Task<Branch> AddAsync(Branch branch);

    Task<Branch> UpdateAsync(Branch branch);

    Task<bool> DeleteAsync(int id);
}