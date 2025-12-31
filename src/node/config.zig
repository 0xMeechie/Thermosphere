const std = @import("std");
const fs = std.fs;

pub const configError = error{HomeNotSet};

const DEFAULT_CONFIG_LOCATION = "/.config/thermosphere";

pub const nodeConfig = struct {
    allocator: std.mem.Allocator,
    configPath: ?[]u8 = null,

    pub fn init(allocator: std.mem.Allocator) nodeConfig {
        return .{ .allocator = allocator };
    }

    pub fn updateConfigPath(self: *nodeConfig, configPath: []const u8) !void {
        if (self.configPath) |oldConfigPath| {
            self.allocator.free(oldConfigPath);
        }

        const path = try self.allocator.dupe(u8, configPath);
        self.configPath = path;
    }

    pub fn deinit(self: *nodeConfig) void {
        if (self.configPath) |oldConfigPath| {
            self.allocator.free(oldConfigPath);
        }
    }
};
pub fn setupConfigLocation() void {}

// returns the full config path.
// ~/$HOME/.config/Thermosphere
fn generateFulConfigPath(allocater: std.mem.Allocator) ![]u8 {
    const homeDir = std.process.getEnvVarOwned(allocater, "HOME") catch return configError.HomeNotSet;
    defer allocater.free(homeDir);

    if (homeDir.len == 0) {
        return configError.HomeNotSet;
    }

    const configPath = try std.mem.concat(allocater, u8, &.{ homeDir, DEFAULT_CONFIG_LOCATION });

    return configPath;
}
// check to see if the config location exist
fn doesConfigLocationExist(configPath: []u8) !bool {
    const cwd = fs.cwd();

    _ = cwd.openDir(configPath, .{}) catch |err| {
        if (err == fs.OpenSelfExeError.FileNotFound) {
            std.debug.print("Couldn't find dir \n", .{});
            return false;
        }

        if (err == fs.OpenSelfExeError.NotDir) {
            std.debug.print("this is not a directory \n", .{});
            return false;
        }

        std.debug.print("not found \n", .{});
        return err;
    };

    std.debug.print("found \n", .{});
    return true;
}

fn createConfigDirectory(configPath: []u8) !void {
    try fs.cwd().makeDir(configPath);
}

fn createConfigFile() void {}

pub fn initConfig(allocater: std.mem.Allocator) !void {
    const configPath = try generateFulConfigPath(allocater);
    defer allocater.free(configPath);

    if (!(try doesConfigLocationExist(configPath))) {
        std.debug.print("Doesnt exist. Create it \n", .{});
        try createConfigDirectory(configPath);
        std.debug.print("{s} has been created \n", .{configPath});
    }
}
