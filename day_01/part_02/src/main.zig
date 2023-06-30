const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("src/input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());

    var buf: [1024]u8 = undefined;

    var first_max: i32 = 0;
    var second_max: i32 = 0;
    var third_max: i32 = 0;
    var total_value: i32 = 0;
    while (try buf_reader.reader().readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const value = std.fmt.parseInt(i32, std.mem.trim(u8, line, "\r"), 10) catch -1;
        if (value == -1) {
            std.log.info("Line len, {}", .{line.len});
            if (total_value != 0) {
                if (first_max < total_value) {
                    third_max = second_max;
                    second_max = first_max;
                    first_max = total_value;
                    std.log.info("First max set value: {d}", .{first_max});
                } else if (second_max < total_value) {
                    third_max = second_max;
                    second_max = total_value;
                    std.log.info("Second max set value: {d}", .{second_max});
                } else if (third_max < total_value) {
                    third_max = total_value;
                    std.log.info("Third max set value: {d}", .{third_max});
                }
            }
            total_value = 0;
        } else {
            total_value += value;
        }
    }
    std.log.info("First max value: {d}", .{first_max});
    std.log.info("Second max value: {d}", .{second_max});
    std.log.info("Third max value: {d}", .{third_max});
    std.log.info("Total max value: {d}", .{first_max + second_max + third_max});
}
