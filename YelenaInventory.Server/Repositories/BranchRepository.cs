using Microsoft.EntityFrameworkCore;
using YelenaInventory.Server.Data;
using YelenaInventory.Server.Models;

namespace YelenaInventory.Server.Repositories;

public class BranchRepository : IBranchRepository
{
    private readonly AppDbContext _db;

    public BranchRepository(AppDbContext db)
    {
        _db = db;
    }

    public async Task<List<Branch>> GetAllAsync()
    {
        return await _db.Branches
            .OrderBy(x => x.Name)
            .ToListAsync();
    }

    public async Task<Branch?> GetByIdAsync(int id)
    {
        return await _db.Branches.FindAsync(id);
    }

    public async Task<Branch> AddAsync(Branch branch)
    {
        _db.Branches.Add(branch);

        await _db.SaveChangesAsync();

        return branch;
    }
}