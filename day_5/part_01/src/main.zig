const std = @import("std");
const utils = @import("utils");
const ArrayList = std.ArrayList;
const AutoHashMap = std.AutoHashMap;
const SplitIterator = std.mem.SplitIterator;

const src = @import("config").src;

const CrateAction = struct {
    move: u16,
    from: u8,
    to: u8,
};

pub fn main() !void {
    var allocator = std.heap.page_allocator;

    var list = ArrayList([]const u8).init(allocator);
    defer list.deinit();
    try utils.getArrayListFromPath(allocator, &list, src ++ "src/input.txt");

    var structure: AutoHashMap(u8, ArrayList(u8)) = AutoHashMap(u8, ArrayList(u8)).init(allocator);
    defer structure.deinit();

    var actions = ArrayList(CrateAction).init(allocator);
    defer actions.deinit();

    const actions_part_index = for (list.items, 0..) |item, index| {
        if (item.len == 0) {
            break index;
        }
    } else 0;

    // Creates and initializes the crate structure
    const crates_stacks_text: []const u8 = list.items[actions_part_index - 1];
    var crates_stacks = std.mem.splitSequence(u8, crates_stacks_text[1 .. crates_stacks_text.len - 1], "   ");
    var crates_index: u8 = undefined;
    while (crates_stacks.next()) |item| {
        crates_index = try std.fmt.parseInt(u8, item, 10);
        try structure.put(crates_index, ArrayList(u8).init(allocator));
    }

    // Interates in inverser order the crate contents
    var n = actions_part_index - 1;
    while (n != 0) : (n -= 1) {
        const crate_row = list.items[n - 1];
        var crate_column_index: usize = 1;
        var structure_column_index: u8 = 1;

        // Interates the crates boxes and populates the crates box by box
        while (crate_column_index < crate_row.len) : ({
            crate_column_index += 4;
            structure_column_index += 1;
        }) {
            if (structure.getPtr(structure_column_index)) |structure_column| {
                if (crate_row[crate_column_index] != ' ') {
                    try structure_column.append(crate_row[crate_column_index]);
                }
            }
        }
    }

    // Populates the crate move actions
    for (list.items[actions_part_index + 1 ..]) |item| {
        var split_item: SplitIterator(u8, .any) = std.mem.splitAny(u8, item[4..], " ");
        const first_part: []const u8 = getValueFromSplit(&split_item) orelse "";
        const second_part: []const u8 = getValueFromSplit(&split_item) orelse "";
        const third_part: []const u8 = getValueFromSplit(&split_item) orelse "";
        try actions.append(CrateAction{ .move = try std.fmt.parseInt(u16, first_part, 10), .from = try std.fmt.parseInt(u8, second_part, 10), .to = try std.fmt.parseInt(u8, third_part, 10) });
    }

    // Logs the current crate structure
    logStructure(crates_index, structure);

    // Moves the crates
    for (actions.items) |action| {
        // Gets the moved column
        if (structure.getPtr(action.from)) |from_column| {
            var moved_values = ArrayList(u8).init(allocator);
            defer moved_values.deinit();
            if (from_column.items.len > 0) {
                // Removes the boxes from the targeted crate
                for (0..action.move) |_| {
                    try moved_values.append(from_column.pop());
                }
                // Adds the boxes to the targeted crate
                if (structure.getPtr(action.to)) |to_column| {
                    for (moved_values.items) |moved_value| {
                        try to_column.append(moved_value);
                    }
                }
            }
        }
    }

    // Logs the new crate structure
    logStructure(crates_index, structure);
}

pub fn logStructure(crates_index: u8, structure: AutoHashMap(u8, ArrayList(u8))) void {
    for (1..crates_index + 1) |index| {
        if (structure.get(@intCast(index))) |item| {
            for (item.items) |box| {
                std.log.info("box: {d} {c}", .{ index, box });
            }
        }
    }
}

pub fn getValueFromSplit(split_item: *SplitIterator(u8, .any)) ?[]const u8 {
    _ = split_item.next();
    return split_item.next();
}
