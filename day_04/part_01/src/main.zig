const std = @import("std");
const utils = @import("utils");
const ArrayList = std.ArrayList;
const ArrayListAligned = std.ArrayListAligned;
const SplitIterator = std.mem.SplitIterator;

const Range = struct {
    start: u32,
    end: u32,

    pub fn isContained(self: *Range, other: Range) bool {
        return (self.start <= other.start) and (self.end >= other.end);
    }
};

pub fn main() !void {
    var allocator = std.heap.page_allocator;

    var list = ArrayList([]const u8).init(allocator);
    try utils.getArrayListFromPath(allocator, &list, "src/input.txt");
    defer list.deinit();

    var same_pairs: u64 = 0;

    for (list.items) |item| {
        var splitted_item: SplitIterator(u8, .any) = std.mem.splitAny(u8, item, ",");
        const first_part: []const u8 = splitted_item.next() orelse "";
        var first_range: Range = getRange(first_part);

        const second_part: []const u8 = splitted_item.next() orelse "";
        var second_range: Range = getRange(second_part);

        if (first_range.isContained(second_range) or second_range.isContained(first_range)) {
            same_pairs += 1;
        }
    }

    std.log.info("same_pairs: {any}", .{same_pairs});
}

pub fn getRange(part: []const u8) Range {
    var splitted_part = std.mem.splitAny(u8, part, "-");
    return Range{ .start = getValueFromOptionalString(splitted_part.next()), .end = getValueFromOptionalString(splitted_part.next()) };
}

pub fn getValueFromOptionalString(opt_string: ?[]const u8) u32 {
    var first_part = opt_string orelse "";
    return std.fmt.parseInt(u32, first_part, 10) catch 0;
}
