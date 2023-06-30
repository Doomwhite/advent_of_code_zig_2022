const std = @import("std");
const utils = @import("utils");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const ArrayListAligned = std.ArrayListAligned;
const ComptimeStringMap = std.ComptimeStringMap;

// const lower_case_map = ComptimeStringMap(u8, .{
//     .{ "a", 1 },
//     .{ "b", 2 },
//     .{ "c", 3 },
//     .{ "d", 4 },
//     .{ "e", 5 },
//     .{ "f", 6 },
//     .{ "g", 7 },
//     .{ "h", 8 },
//     .{ "i", 9 },
//     .{ "j", 10 },
//     .{ "k", 11 },
//     .{ "l", 12 },
//     .{ "m", 13 },
//     .{ "n", 14 },
//     .{ "o", 15 },
//     .{ "p", 16 },
//     .{ "q", 17 },
//     .{ "r", 18 },
//     .{ "s", 19 },
//     .{ "t", 20 },
//     .{ "u", 21 },
//     .{ "v", 22 },
//     .{ "w", 23 },
//     .{ "x", 24 },
//     .{ "y", 25 },
//     .{ "z", 26 },
// });

const lower_case_items = [_]u8{ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };

// const upper_case_items = [_]u8{ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };

pub fn main() !void {
    var allocator = std.heap.page_allocator;
    var list = ArrayList([]const u8).init(allocator);
    try utils.getArrayListFromPath(allocator, &list, "src/input.txt");
    defer list.deinit();

    var total_value: u32 = 0;
    var alreadyCheckedList = ArrayList(u32).init(allocator);
    defer alreadyCheckedList.deinit();
    for (list.items) |line| {
        alreadyCheckedList = ArrayList(u32).init(allocator);
        var first_half = line[0 .. line.len / 2];
        var second_half = line[line.len / 2 .. line.len];
        // std.log.info("{}", .{@TypeOf(&total_value)});
        for (first_half) |first_half_item| {
            try checkValues(&alreadyCheckedList, &total_value, second_half, first_half_item);
        }
        log_line_info(total_value, line, first_half, second_half);

        // var first_half = ;
    }

    std.debug.print("alreadyCheckedList: {any}\n", .{alreadyCheckedList.items});
    for (alreadyCheckedList.items) |index| {
        if (index <= 52) {
            std.debug.print("{c}\n", .{lower_case_items[index]});
        }
        // else if (index <= 50) {
        //     std.debug.print("{c}\n", .{upper_case_items[index - 26]});
        // }
        // else if (index <= 52) {
        //     std.debug.print("{c}\n", .{upper_case_items[index - 26]});
        // }
    }
    std.log.info("{d}", .{total_value});
    // std.log.info("{s}", .{list.items});
    // std.log.info("{any}", .{list.items});
    // std.log.info("{any}", .{@TypeOf(lower_case_items)});
}

fn checkValues(alreadyCheckedList: *ArrayListAligned(u32, null), total_value: *u32, source: []const u8, target: u8) !void {
    var allocator = std.heap.page_allocator;
    var list = ArrayList(u8).init(allocator);
    defer list.deinit();

    for (source) |item| {
        if (item == target) {
            // std.debug.print("{any}\n", .{item});
            // std.debug.print("{}\n", .{@TypeOf(upper_case_items)});

            const teste1 = @as(u32, @intCast(getIndexFromArray(lower_case_items, item)));
            if (teste1 <= lower_case_items.len - 1) {
                std.debug.print("Teste1: {c}\n", .{lower_case_items[teste1]});
            }
            const lower_case_value = @as(u32, @intCast(getIndexFromArray(lower_case_items, item)));

            // const teste2 = @as(u32, @intCast(getIndexFromArray(upper_case_items, item)));
            // if (teste2 <= upper_case_items.len - 1) {
            //     std.debug.print("Teste2: {c}\n", .{upper_case_items[teste2]});
            // }

            // std.debug.print("{}\n", .{contains(alreadyCheckedList, lower_case_value)});
            if (!contains(alreadyCheckedList, lower_case_value)) {
                // std.debug.print("lower_case_value: {}\n", .{lower_case_value});
                total_value.* += lower_case_value + 1;
                try alreadyCheckedList.*.append(lower_case_value);
                // std.debug.print("alreadyCheckedList: {any}\n", .{alreadyCheckedList.items});
            }
            // var upper_case_value = @as(u32, @intCast(getIndexFromArray(upper_case_items, item))) + 1;
            // upper_case_value += @as(u32, @intCast(lower_case_items.len));
            // if (!contains(alreadyCheckedList, upper_case_value)) {
            //     // std.debug.print("upper_case_value: {}\n", .{upper_case_value});
            //     total_value.* += upper_case_value;
            //     try alreadyCheckedList.*.append(upper_case_value);
            //     // std.debug.print("alreadyCheckedList: {any}\n", .{alreadyCheckedList.items});
            // }
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
