using Microsoft.AspNetCore.Mvc;
using YelenaInventory.Server.DTOs;
using YelenaInventory.Server.Services;

namespace YelenaInventory.Server.Controllers;

[ApiController]
[Route("api/[controller]")]
public class BranchesController : ControllerBase
{
    private readonly IBranchService _service;

    public BranchesController(IBranchService service)
    {
        _service = service;
    }

    [HttpGet]
    public async Task<ActionResult<List<BranchDto>>> GetAll()
    {
        return Ok(await _service.GetAllAsync());
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<BranchDto>> GetById(int id)
    {
        var branch = await _service.GetByIdAsync(id);

        if (branch == null)
            return NotFound();

        return Ok(branch);
    }

    [HttpPost]
    public async Task<ActionResult<BranchDto>> Create(BranchDto dto)
    {
        var created = await _service.CreateAsync(dto);

        return CreatedAtAction(
            nameof(GetById),
            new { id = created.Id },
            created);
    }

    [HttpPut("{id:int}")]
    public async Task<ActionResult<BranchDto>> Update(
        int id,
        BranchDto dto)
    {
        var updated = await _service.UpdateAsync(id, dto);

        if (updated == null)
            return NotFound();

        return Ok(updated);
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await _service.DeleteAsync(id);

        if (!deleted)
            return NotFound();

        return NoContent();
    }
}