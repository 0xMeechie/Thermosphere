const std = @import("std");
const fs = std.fs;

const DEFAULT_CONFIG_LOCATION = "~/Downloads/";

pub fn configLocationExist(allocater: std.mem.Allocator) !void {
    const homeDir = try std.process.getEnvVarOwned(allocater, "HOME");
    std.debug.print("Home Dir is : {s}", .{homeDir});
    defer allocater.free(homeDir);
}
