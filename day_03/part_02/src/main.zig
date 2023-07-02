const std = @import("std");
const utils = @import("utils");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const ArrayListAligned = std.ArrayListAligned;
const ComptimeStringMap = std.ComptimeStringMap;

const priority_item_list = [_]u8{ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };

pub fn main() !void {
    var allocator = std.heap.page_allocator;

    var list = ArrayList([]const u8).init(allocator);
    try utils.getArrayListFromPath(allocator, &list, "src/input.txt");
    defer list.deinit();

    var three_line_list = ArrayList([3][]const u8).init(allocator);
    try populateArrayList(&three_line_list, list);
    defer three_line_list.deinit();

    var total_value: u32 = 0;
    var index: u64 = 0;
    for (three_line_list.items) |three_line_item| {
        var already_checked_list = ArrayList(u32).init(allocator);
        defer already_checked_list.deinit();

        for (three_line_item[0]) |first_line_char| {
            for (three_line_item[1]) |second_line_char| {
                for (three_line_item[2]) |third_line_char| {
                    index += 1;
                    if (first_line_char == second_line_char and second_line_char == third_line_char) {
                        const list_index_value = @intCast(u32, getIndexFromArray(priority_item_list, first_line_char));

                        if (!contains(already_checked_list, list_index_value)) {
                            total_value += list_index_value + 1;
                            try already_checked_list.append(list_index_value);
                        }
                    }
                    // std.log.info("{s}", .{[3]u8{ first_line_char, second_line_char, third_line_char }});
                }
            }
        }
    }

    std.log.info("{d}", .{total_value});
    std.log.info("{d}", .{index});
}

fn populateArrayList(three_line_list: *ArrayListAligned([3][]const u8, null), list: ArrayListAligned([]const u8, null)) !void {
    var index: u32 = 0;
    while (index <= list.items.len - 1) : (index += 3) {
        try three_line_list.*.append([3][]const u8{ list.items[index], list.items[index + 1], list.items[index + 2] });
    }
}

fn contains(source: ArrayListAligned(u32, null), needle: u32) bool {
    return for (source.items) |sourceItem| {
        if (sourceItem == needle) {
            break true;
        }
    } else false;
}

fn getIndexFromArray(source: [52]u8, target: u8) usize {
    var n: usize = 0;
    while (n <= source.len - 1) : (n += 1) {
        if (source[n] == target) {
            return n;
        }
    }
    return n;
}
