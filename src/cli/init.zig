const std = @import("std");
const Writer = std.Io.Writer;
const Reader = std.Io.Reader;
const zli = @import("zli");

const config = @import("../node/config.zig");

pub fn register(writer: *Writer, reader: *Reader, allocator: std.mem.Allocator) !*zli.Command {
    return zli.Command.init(writer, reader, allocator, .{
        .name = "init",
        .shortcut = "i",
        .description = "initialize the node",
    }, initNode);
}

fn initNode(ctx: zli.CommandContext) !void {
    try config.configLocationExist(ctx.allocator);
    try ctx.writer.print("the node is initializing", .{});
}
