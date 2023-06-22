const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("src/input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var buf: [1024]u8 = undefined;

    while (try buf_reader.reader().readUntilDelimiterOrEof(&buf, '\n')) |lineWithCR| {
        var line = std.mem.split(u8, std.mem.trim(u8, lineWithCR, "\r"), " ");
        const firstLetter: []const u8 = line.next().?;
        const secondLetter: []const u8 = line.next().?;
        std.log.info("{any}", .{line});
        std.log.info("{s}", .{secondLetter});
        std.log.info("{s}", .{firstLetter});
        // if (line.len < 4) break;
        // const firstLetter = line[0];
        // const secondLetter = line[0];
    }
}

// pub fn getLine(lineWithCR: []const u8) SplitIterator(u8) {
//     return std.mem.split(u8, std.mem.trim(u8, lineWithCR, "\r"), " ");
// }
