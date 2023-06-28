const std = @import("std");
const utils = @import("utils");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const ArrayListAligned = std.ArrayListAligned;

pub fn main() !void {
    var allocator = std.heap.page_allocator;
    var list = ArrayList([]const u8).init(allocator);
    try utils.getArrayListFromPath(allocator, &list, "src/input.txt");
    defer list.deinit();

    std.log.info("{s}", .{list.items});
}

// pub fn getArrayListFromPath(allocator: Allocator, list: *ArrayListAligned([]const u8, null), fileName: []const u8) !void {
//     var file = try std.fs.cwd().openFile(fileName, .{});
//     defer file.close();
//
//     var buf_reader = std.io.bufferedReader(file.reader());
//     var buf: [1024]u8 = undefined;
//
//     while (try buf_reader.reader().readUntilDelimiterOrEof(&buf, '\n')) |line| {
//         const lineValue: []const u8 = std.mem.trim(u8, line, "\r");
//         try list.append(try std.mem.Allocator.dupe(allocator, u8, lineValue));
//     }
// }
