const std = @import("std");
const ArrayList = std.ArrayList;

export fn getArrayListFromFile(fileName: []const u8) !std.ArrayList([]const u8) {
    const allocator = std.heap.page_allocator;

    var list = ArrayList([]const u8).init(allocator);
    defer list.deinit();

    var file = try std.fs.cwd().openFile(fileName, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var buf: [1024]u8 = undefined;

    while (try buf_reader.reader().readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try list.append(std.mem.trim(u8, line, "\r"));
    }

    return list;
}
