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

    var total_value: u32 = 0;
    for (list.items) |line| {
        var alreadyCheckedList = ArrayList(u32).init(allocator);
        defer alreadyCheckedList.deinit();

        var first_half: []const u8 = line[0 .. line.len / 2];
        var second_half: []const u8 = line[line.len / 2 .. line.len];
        for (first_half) |first_half_item| {
            try checkValues(&alreadyCheckedList, &total_value, second_half, first_half_item);
        }
        log_line_info(total_value, line, first_half, second_half);
    }

    std.log.info("{d}", .{total_value});
}

fn checkValues(alreadyCheckedList: *ArrayListAligned(u32, null), total_value: *u32, source: []const u8, target: u8) !void {
    var allocator = std.heap.page_allocator;
    var list = ArrayList(u8).init(allocator);
    defer list.deinit();

    for (source) |item| {
        if (item == target) {
            const list_index_value = @intCast(u32, getIndexFromArray(priority_item_list, item));

            if (!contains(alreadyCheckedList, list_index_value)) {
                total_value.* += list_index_value + 1;
                try alreadyCheckedList.*.append(list_index_value);
            }
        }
    }
}

fn contains(source: *ArrayListAligned(u32, null), target: u32) bool {
    return for (source.items) |sourceItem| {
        if (sourceItem == target) {
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

fn log_line_info(total_value: u32, line: []const u8, first_half: []const u8, second_half: []const u8) void {
    std.debug.print("Total value: {d}\n", .{total_value});
    std.debug.print("Line: {s}\n", .{line});
    std.debug.print("Line length: {d}\n", .{line.len});
    std.debug.print("Line first half: {s}\n", .{first_half});
    std.debug.print("Line second half: {s}\n\n", .{second_half});
}
