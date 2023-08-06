const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const ArrayListAligned = std.ArrayListAligned;

pub fn getArrayListFromPath(allocator: Allocator, list: *ArrayListAligned([]const u8, null), fileName: []const u8) !void {
    var file = try std.fs.cwd().openFile(fileName, .{});
    defer file.close();

    var file_buffer_reader = std.io.bufferedReader(file.reader());
    var buffer: [1024]u8 = undefined;

    while (try file_buffer_reader.reader().readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        const lineValue: []const u8 = std.mem.trim(u8, line, "\r");
        try list.append(try std.mem.Allocator.dupe(allocator, u8, lineValue));
    }
}

pub fn getStringFromPath(fileName: []const u8) ![]const u8 {
    var file = try std.fs.cwd().openFile(fileName, .{});
    defer file.close();

    var file_buffer_reader = std.io.bufferedReader(file.reader());
    var buffer: [9000]u8 = undefined;

    return while (try file_buffer_reader.reader().readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        break std.mem.trim(u8, line, "\r");
    } else "";
}
