const std = @import("std");
const utils = @import("utils");
const ArrayList = std.ArrayList;
const SplitIterator = std.mem.SplitIterator;

const CrateAction = struct {
    move: i16,
    from: i16,
    to: i16,
};

pub fn main() !void {
    var allocator = std.heap.page_allocator;

    var list = ArrayList([]const u8).init(allocator);
    defer list.deinit();
    try utils.getArrayListFromPath(allocator, &list, "src/input_demo.txt");

    var structure = ArrayList([]u8).init(allocator);
    defer structure.deinit();

    var actions = ArrayList(CrateAction).init(allocator);
    defer actions.deinit();

    const actions_part_index = for (list.items, 0..) |item, index| {
        if (item.len == 0) {
            break index + 1;
        }
    } else 0;

    for (list.items[0 .. actions_part_index - 1]) |item| {
        std.log.info("{any}", .{item});
    }

    for (list.items[actions_part_index..]) |item| {
        var split_item: SplitIterator(u8, .any) = std.mem.splitAny(u8, item[4..], " ");
        const first_part: []const u8 = getValueFromSplit(&split_item) orelse "";
        const second_part: []const u8 = getValueFromSplit(&split_item) orelse "";
        const third_part: []const u8 = getValueFromSplit(&split_item) orelse "";
        try actions.append(CrateAction{ .move = try std.fmt.parseInt(i16, first_part, 10), .from = try std.fmt.parseInt(i16, second_part, 10), .to = try std.fmt.parseInt(i16, third_part, 10) });
    }

    for (actions.items) |item| {
        std.log.info("{any}", .{item});
    }
}

pub fn getValueFromSplit(split_item: *SplitIterator(u8, .any)) ?[]const u8 {
    _ = split_item.next();
    return split_item.next();
}
