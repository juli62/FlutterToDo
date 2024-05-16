using Microsoft.EntityFrameworkCore;

namespace FlutterToDo_back.models;

public class TodoContext : DbContext
{

    public TodoContext(DbContextOptions<TodoContext> options) : base(options) { }

    public DbSet<TodoItem> TodoItems { get; set; } = null!;

}