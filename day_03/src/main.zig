const std = @import("std");
const ArrayList = std.ArrayList;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var list = ArrayList(ArrayList(u8)).init(allocator);
    defer list.deinit();

    var file = try std.fs.cwd().openFile("src/input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var buf: [1024]u8 = undefined;

    while (try buf_reader.reader().readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const value = ArrayList(u8).init(allocator);
        const origin = std.mem.trim(u8, line, "\r");
        try value.append(origin[0..origin.len]);
        // for (origin) |originChar| {
        //     std.log.info("{}", .{@typeInfo(@TypeOf(originChar))});
        //     value.append(originChar);
        // }
        // value.append(origin[0..origin.len]);
        try list.append(value);
    }

    for (list.items) |itemsList| {
        std.log.info("3 {any}", .{itemsList.items});
    }

    // std.log.info("3 {any}", .{list.items});
    // for (list.items) |line| {
    //     std.log.info("{any}", .{line});
    // }
}

// export fn getArrayListFromFile(fileName: []const u8) !std.ArrayList([]const u8) {
//
//     return list;
// }
