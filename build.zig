const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.

const ComputationError = error{
    OutOfRange,
};

pub fn build(b: *std.Build) !void {
    const alloc = std.heap.page_allocator;

    const day: ?u6 = b.option(u6, "d", "The day of advent of code");
    const part: u2 = b.option(u2, "p", "The part of the day of advent of code") orelse 1;
    if (day) |day_value| {
        if ((day_value > 25) or (day_value == 0)) return ComputationError.OutOfRange;
    }
    if (part == 0) unreachable;

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    if (day) |day_value| {
        const path: []const u8 = try getPath(alloc, day_value, part);

        // Check file exists
        try std.fs.cwd().access(path, .{});
        const exe = b.addExecutable(.{
            .name = "day",
            .root_source_file = .{ .path = path },
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

        const options = b.addOptions();
        const src = std.fmt.allocPrint(alloc, "day_{d}/part_0{d}/", .{ day_value, part }) catch unreachable;
        options.addOption([]const u8, "src", src);
        exe.addOptions("config", options);

        const utilsModule = b.addModule("utils", .{ .source_file = .{ .path = "utils/utils.zig" } });
        exe.addModule("utils", utilsModule);
    }
}

fn getPath(alloc: std.mem.Allocator, day: u6, part: u2) ![]const u8 {
    return try std.fmt.allocPrint(alloc, "day_{d}/part_0{d}/src/main.zig", .{ day, part });
}
