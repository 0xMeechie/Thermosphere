const std = @import("std");
const Writer = std.Io.Writer;
const Reader = std.Io.Reader;
const zli = @import("zli");

pub fn register(writer: *Writer, reader: *Reader, allocator: std.mem.Allocator) !*zli.Command {
    return zli.Command.init(writer, reader, allocator, .{
        .name = "serve",
        .shortcut = "s",
        .description = "starting agent",
    }, serve);
}

fn serve(ctx: zli.CommandContext) !void {
    try ctx.writer.print("I'm serving up some good shit here", .{});
}
