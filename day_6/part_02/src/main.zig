const std = @import("std");
const utils = @import("utils");
const BoundedArray = std.BoundedArray;

const min_char_count_for_marker: comptime_int = 14;

const src = @import("config").src;

pub fn main() !void {
    var list = try BoundedArray(u8, min_char_count_for_marker).init(min_char_count_for_marker);

    const string: []const u8 = utils.getStringFromPath(src ++ "src/input.txt") catch "";

    const index = for_loop: for (string, 0..) |character, char_index| {
        std.log.info("{any}", .{char_index});
        if (list.len != min_char_count_for_marker) {
            try list.append(character);
        } else {
            const replaced_array: []const u8 = &list.buffer[1..].* ++ [1]u8{character};
            try list.replaceRange(0, min_char_count_for_marker, replaced_array);
        }
        std.log.info("{s}", .{list.buffer});
        if (char_index > min_char_count_for_marker) {
            var is_different_count: u8 = 0;
            for (list.buffer, 0..) |list_item, item_index| {
                var char_is_different_count: u8 = 0;

                for (list.buffer, 0..) |second_list_item, second_item_index| {
                    if (item_index == second_item_index) {
                        continue;
                    }
                    if (list_item != second_list_item) {
                        char_is_different_count += 1;
                    }
                }

                if (char_is_different_count == min_char_count_for_marker - 1) {
                    is_different_count += 1;
                }
            }
            if (is_different_count == min_char_count_for_marker) {
                break :for_loop char_index + 1;
            }
        }
    } else 0;
    std.log.info("index: {any}", .{index});
}
