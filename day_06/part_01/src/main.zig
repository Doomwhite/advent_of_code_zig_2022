const std = @import("std");
const utils = @import("utils");
const BoundedArray = std.BoundedArray;

const min_char_count_for_marker: comptime_int = 3;

pub fn main() !void {
    var list = try BoundedArray(u8, 4).init(4);

    const string: []const u8 = utils.getStringFromPath("src/input.txt") catch "";

    const index = for_loop: for (string, 0..) |character, char_index| {
        if (list.len != 4) {
            try list.append(character);
        } else {
            const replaced_array: []const u8 = &list.buffer[1..].* ++ [1]u8{character};
            try list.replaceRange(0, 4, replaced_array);
        }
        if (char_index > min_char_count_for_marker) {
            var is_different_count: u8 = 0;
            for (list.buffer, 0..) |list_item, item_index| {
                if (item_index == 0) {
                    if (list_item != list.buffer[1] and list_item != list.buffer[2] and list_item != list.buffer[3]) {
                        is_different_count += 1;
                    }
                }
                if (item_index == 1) {
                    if (list_item != list.buffer[0] and list_item != list.buffer[2] and list_item != list.buffer[3]) {
                        is_different_count += 1;
                    }
                }
                if (item_index == 2) {
                    if (list_item != list.buffer[0] and list_item != list.buffer[1] and list_item != list.buffer[3]) {
                        is_different_count += 1;
                    }
                }
                if (item_index == 3) {
                    if (list_item != list.buffer[0] and list_item != list.buffer[1] and list_item != list.buffer[2]) {
                        is_different_count += 1;
                    }
                }
            }
            if (is_different_count == 4) {
                break :for_loop char_index + 1;
            }
        }
    } else 0;
    std.log.info("index: {any}", .{index});
}
