const std = @import("std");
const Writer = std.Io.Writer;
const Reader = std.Io.Reader;
const zli = @import("zli");

pub fn register(writer: *Writer, reader: *Reader, allocator: std.mem.Allocator) !*zli.Command {
    return zli.Command.init(writer, reader, allocator, .{
        .name = "id",
        .shortcut = "id",
        .description = "return the id of the node",
    }, showID);
}

fn showID(ctx: zli.CommandContext) !void {
    try ctx.writer.print("The id of the node is Here \n", .{});
}
