const std = @import("std");

const src = @import("config").src;

pub fn main() !void {
    var file = try std.fs.cwd().openFile(src ++ "src/input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var buf: [1024]u8 = undefined;

    // A = Rock
    // B = Paper
    // C = Scissor

    // Y = Paper
    // X = Rock
    // Z = Scissor

    // First part choices
    // const choices: [3][3]u8 = [3][3]u8{ [_]u8{ 4, 8, 3 }, [_]u8{ 1, 5, 9 }, [_]u8{ 7, 2, 6 } };

    // X = Lose
    // Y = Draw
    // Z = Win

    // Second part choices
    const choices: [3][3]u8 = [3][3]u8{ [_]u8{ 3, 4, 8 }, [_]u8{ 1, 5, 9 }, [_]u8{ 2, 6, 7 } };
    // Hell yeahhhh, first time

    // Ok, doing it by matrix is the right way.
    var total_score: u32 = 0;
    while (try buf_reader.reader().readUntilDelimiterOrEof(&buf, '\n')) |lineWithCR| {
        var line = std.mem.split(u8, std.mem.trim(u8, lineWithCR, "\r"), " ");
        // std.log.info("{any}", .{line});
        const first_letter: []const u8 = line.next() orelse "";
        const second_letter: []const u8 = line.next() orelse "";

        const op_value: usize = switch (first_letter[0]) {
            'A' => 0,
            'B' => 1,
            'C' => 2,
            else => 4,
        };
        std.log.info("{any}\n", .{op_value});

        const my_value: usize = switch (second_letter[0]) {
            'X' => 0,
            'Y' => 1,
            'Z' => 2,
            else => 4,
        };
        std.log.info("{any}\n", .{my_value});

        if (op_value == 4 or my_value == 4) continue;
        const value = choices[op_value][my_value];
        total_score += value;

        std.log.info("The score: {d}", .{value});

        // std.log.info("The Opponent's choice: {d}", .{op_value});
        // std.log.info("My choice: {d}", .{my_value});
        // if (line.len < 4) break;
        // const firstLetter = line[0];
        // const secondLetter = line[0];
    }
    std.log.info("{}", .{total_score});
}

// pub fn getLine(lineWithCR: []const u8) SplitIterator(u8) {
//     return std.mem.split(u8, std.mem.trim(u8, lineWithCR, "\r"), " ");
// }
