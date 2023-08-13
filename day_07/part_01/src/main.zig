const std = @import("std");
const utils = @import("utils");
const ArrayList = std.ArrayList;
const ArrayListAligned = std.ArrayListAligned;

const DirectoryNode = struct { name: []const u8, parent: DirectoryNode, child: ArrayListAligned(DirectoryNode), size: i32 };

pub fn main() !void {
    var allocator = std.heap.page_allocator;
    var list: ArrayListAligned([]const u8, null) = ArrayList([]const u8).init(allocator);
    defer list.deinit();

    try utils.getArrayListFromPath(allocator, &list, "src/input_demo.txt");
    for (list.items) |item| {
        std.log.info("list: {s}", .{item});
    }
}
