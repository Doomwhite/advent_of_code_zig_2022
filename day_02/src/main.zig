const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("src/input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var buf: [1024]u8 = undefined;

    // Ok, doing it by matrix is the right way.
    while (try buf_reader.reader().readUntilDelimiterOrEof(&buf, '\n')) |lineWithCR| {
        var line = std.mem.split(u8, std.mem.trim(u8, lineWithCR, "\r"), " ");
        // std.log.info("{any}", .{line});
        const first_letter: []const u8 = line.next() orelse "";
        const second_letter: []const u8 = line.next() orelse "";
        const op_value: []const u8 = switch (first_letter[0]) {
            'A' => "Rock",
            'B' => "Paper",
            'C' => "Scissor",
            else => unreachable,
        };

        std.log.info("Opponent choose: {s}", .{op_value});
        std.log.info("I choose: {s}", .{second_letter});
        // if (line.len < 4) break;
        // const firstLetter = line[0];
        // const secondLetter = line[0];
    }
}

// pub fn getLine(lineWithCR: []const u8) SplitIterator(u8) {
//     return std.mem.split(u8, std.mem.trim(u8, lineWithCR, "\r"), " ");
// }
