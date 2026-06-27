using YelenaInventory.Server.Models;

namespace YelenaInventory.Server.Repositories;

public interface IBranchRepository
{
    Task<List<Branch>> GetAllAsync();

    Task<Branch?> GetByIdAsync(int id);

    Task<Branch> AddAsync(Branch branch);
}