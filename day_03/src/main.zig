const std = @import("std");
const utils = @import("utils");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const ArrayListAligned = std.ArrayListAligned;

const lower_case_items = [_]u8{ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };

const upper_case_items = [_]u8{ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };

pub fn main() !void {
    var allocator = std.heap.page_allocator;
    var list = ArrayList([]const u8).init(allocator);
    try utils.getArrayListFromPath(allocator, &list, "src/input_demo.txt");
    defer list.deinit();

    var total_value: u32 = 0;
    for (list.items) |line| {
        var first_half = line[0 .. line.len / 2];
        var second_half = line[line.len / 2 .. line.len];
        // std.log.info("{}", .{@TypeOf(&total_value)});
        for (first_half) |first_half_item| {
            checkValues(&total_value, second_half, first_half_item);
        }
        log_line_info(total_value, line, first_half, second_half);

        // var first_half = ;
    }

    // std.log.info("{s}", .{list.items});
    // std.log.info("{any}", .{list.items});
    // std.log.info("{any}", .{@TypeOf(lower_case_items)});
}

fn checkValues(total_value: *u32, source: []const u8, target: u8) void {
    var allocator = std.heap.page_allocator;
    var list = ArrayList(u8).init(allocator);
    defer list.deinit();

    for (source) |item| {
        if (item == target) {
            std.debug.print("{any}\n", .{item});
            total_value.* += 1;
            list.append(item);
        }
    }
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
