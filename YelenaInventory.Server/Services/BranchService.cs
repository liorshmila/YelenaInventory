using YelenaInventory.Server.DTOs;
using YelenaInventory.Server.Models;
using YelenaInventory.Server.Repositories;

namespace YelenaInventory.Server.Services;

public class BranchService : IBranchService
{
    private readonly IBranchRepository _repository;

    public BranchService(IBranchRepository repository)
    {
        _repository = repository;
    }

    public async Task<List<BranchDto>> GetAllAsync()
    {
        var branches = await _repository.GetAllAsync();

        return branches.Select(x => new BranchDto
        {
            Id = x.Id,
            Name = x.Name
        }).ToList();
    }

    public async Task<BranchDto?> GetByIdAsync(int id)
    {
        var branch = await _repository.GetByIdAsync(id);

        if (branch == null)
            return null;

        return new BranchDto
        {
            Id = branch.Id,
            Name = branch.Name
        };
    }

    public async Task<BranchDto> CreateAsync(BranchDto dto)
    {
        var entity = new Branch
        {
            Name = dto.Name
        };

        entity = await _repository.AddAsync(entity);

        return new BranchDto
        {
            Id = entity.Id,
            Name = entity.Name
        };
    }

    public async Task<BranchDto?> UpdateAsync(int id, BranchDto dto)
    {
        var entity = await _repository.GetByIdAsync(id);

        if (entity == null)
            return null;

        entity.Name = dto.Name;

        entity = await _repository.UpdateAsync(entity);

        return new BranchDto
        {
            Id = entity.Id,
            Name = entity.Name
        };
    }

    public Task<bool> DeleteAsync(int id)
    {
        return _repository.DeleteAsync(id);
    }
}