const std = @import("std");
const Writer = std.Io.Writer;
const Reader = std.Io.Reader;
const zli = @import("zli");

pub fn register(writer: *Writer, reader: *Reader, allocator: std.mem.Allocator) !*zli.Command {
    return zli.Command.init(writer, reader, allocator, .{
        .name = "ping",
        .shortcut = "p",
        .description = "pinging a node",
    }, ping);
}

fn ping(ctx: zli.CommandContext) !void {
    try ctx.writer.print("pinging a node \n", .{});
}
