const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.

pub fn build(b: *std.Build) void {
    const paths = [25][2][]const u8{
        [2][]const u8{ "day_1/part_01/src/main.zig", "day_1/part_02/src/main.zig" },
        [2][]const u8{ "day_2/part_01/src/main.zig", "day_2/part_02/src/main.zig" },
        [2][]const u8{ "day_3/part_01/src/main.zig", "day_3/part_02/src/main.zig" },
        [2][]const u8{ "day_4/part_01/src/main.zig", "day_4/part_02/src/main.zig" },
        [2][]const u8{ "day_5/part_01/src/main.zig", "day_5/part_02/src/main.zig" },
        [2][]const u8{ "day_6/part_01/src/main.zig", "day_6/part_02/src/main.zig" },
        [2][]const u8{ "day_7/part_01/src/main.zig", "day_7/part_02/src/main.zig" },
        [2][]const u8{ "day_8/part_01/src/main.zig", "day_8/part_02/src/main.zig" },
        [2][]const u8{ "day_9/part_01/src/main.zig", "day_9/part_02/src/main.zig" },
        [2][]const u8{ "day_10/part_01/src/main.zig", "day_10/part_02/src/main.zig" },
        [2][]const u8{ "day_11/part_01/src/main.zig", "day_11/part_02/src/main.zig" },
        [2][]const u8{ "day_12/part_01/src/main.zig", "day_12/part_02/src/main.zig" },
        [2][]const u8{ "day_13/part_01/src/main.zig", "day_13/part_02/src/main.zig" },
        [2][]const u8{ "day_14/part_01/src/main.zig", "day_14/part_02/src/main.zig" },
        [2][]const u8{ "day_15/part_01/src/main.zig", "day_15/part_02/src/main.zig" },
        [2][]const u8{ "day_16/part_01/src/main.zig", "day_16/part_02/src/main.zig" },
        [2][]const u8{ "day_17/part_01/src/main.zig", "day_17/part_02/src/main.zig" },
        [2][]const u8{ "day_18/part_01/src/main.zig", "day_18/part_02/src/main.zig" },
        [2][]const u8{ "day_19/part_01/src/main.zig", "day_19/part_02/src/main.zig" },
        [2][]const u8{ "day_20/part_01/src/main.zig", "day_20/part_02/src/main.zig" },
        [2][]const u8{ "day_21/part_01/src/main.zig", "day_21/part_02/src/main.zig" },
        [2][]const u8{ "day_22/part_01/src/main.zig", "day_22/part_02/src/main.zig" },
        [2][]const u8{ "day_23/part_01/src/main.zig", "day_23/part_02/src/main.zig" },
        [2][]const u8{ "day_24/part_01/src/main.zig", "day_24/part_02/src/main.zig" },
        [2][]const u8{ "day_25/part_01/src/main.zig", "day_25/part_02/src/main.zig" },
    };

    const day: ?u6 = b.option(u6, "d", "The day of advent of code");
    var part: ?u2 = undefined;
    if (day) |day_value| {
        if ((day_value > 25) or (day_value == 0)) unreachable;

        part = b.option(u2, "p", "The part of the day of advent of code");
        if (part) |part_value| {
            if (part_value == 0) unreachable;
        }
    }

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    if (day) |day_value| {
        const day_string: []const u8 = getDayString(day_value);
        const exe = b.addExecutable(.{
            .name = day_string,
            // In this case the main source file is merely a path, however, in more
            // complicated build scripts, this could be a generated file.
            .root_source_file = .{ .path = paths[4][0] },
            .target = target,
            .optimize = optimize,
        });
        b.installArtifact(exe);

        const run_cmd = b.addRunArtifact(exe);
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        const run_step = b.step("run", "Run the app");
        run_step.dependOn(&run_cmd.step);
    }
}

pub fn getDayString(day_value: u6) []const u8 {
    return "day_" ++ [1]u8{@as(u8, @intCast(day_value))};
}

pub fn getDayPath(day_value: u6) []const u8 {
    return "day_" ++ [1]u8{@as(u8, @intCast(day_value))} ++ "/src";
}
