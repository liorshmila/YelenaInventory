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

    public async Task<Branch> UpdateAsync(Branch branch)
    {
        _db.Branches.Update(branch);

        await _db.SaveChangesAsync();

        return branch;
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var entity = await _db.Branches.FindAsync(id);

        if (entity == null)
            return false;

        _db.Branches.Remove(entity);

        await _db.SaveChangesAsync();

        return true;
    }
}