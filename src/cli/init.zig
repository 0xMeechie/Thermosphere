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
    var nc = config.nodeConfig.init(ctx.allocator);
    defer nc.deinit();

    const cp = "/mypath/sodapoppin";
    std.debug.print("config path is null \n", .{});
    try nc.updateConfigPath(cp);

    std.debug.print("new config path is {s} \n", .{nc.configPath.?});

    config.initConfig(ctx.allocator) catch |err| {
        if (err == config.configError.HomeNotSet) {
            std.debug.print("$HOME is not set. Please set it and try again", .{});
            return;
        }
    };
    try ctx.writer.print("the node is initializing \n", .{});
}
