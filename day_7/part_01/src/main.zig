const std = @import("std");
const utils = @import("utils");
const SplitIterator = std.mem.SplitIterator;
const ArrayList = std.ArrayList;
const ArrayListAligned = std.ArrayListAligned;

const DirectoryNode = struct {
    name: []const u8,
    parent: ?*DirectoryNode,
    child: ?ArrayListAligned(*DirectoryNode, null),
    size: i64,
};

const RowType = enum {
    Command,
    Directory,
    File,
};

pub fn main() !void {
    var allocator = std.heap.page_allocator;
    var list: ArrayListAligned([]const u8, null) = ArrayList([]const u8).init(allocator);
    defer list.deinit();
    try utils.getArrayListFromPath(allocator, &list, "src/input_demo.txt");

    var root_node = DirectoryNode{ .name = "/", .size = 10000, .parent = null, .child = null };
    var child_node = DirectoryNode{ .name = "/", .size = 10000, .parent = &root_node, .child = null };
    var node_list: ArrayListAligned(*DirectoryNode, null) = ArrayList(*DirectoryNode).init(allocator);
    try node_list.append(&child_node);
    root_node.child = node_list;

    std.log.info("root_node: {any}", .{root_node});

    for (root_node.child.?.items) |item| {
        std.log.info("item: {any}", .{item});
    }

    for (list.items) |item| {
        var split_item: SplitIterator(u8, .any) = std.mem.splitAny(u8, item, " ");
        const row_type: RowType = getRowType(&split_item);
        _ = row_type;
        // std.log.info("rowType: {any}", .{row_type});
        // std.log.info("item: {s}", .{item});
    }
    // for (list.items) |item| {
    //     std.log.info("list: {s}", .{item});
    // }
}

fn getRowType(split_item: *SplitIterator(u8, .any)) RowType {
    const first_word: []const u8 = split_item.*.next() orelse "";
    if (std.mem.eql(u8, first_word, "$")) {
        return .Command;
    } else if (std.mem.eql(u8, first_word, "dir")) {
        return .Directory;
    } else {
        return .File;
    }
}
