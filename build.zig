const std = @import("std");
const zlvgl = @import("zlvgl");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const config = zlvgl.Config{
        .driver = .Sdl,
        .gpu = .Sdl,
    };

    const zlvgl_dep = b.dependency("zlvgl", .{
        .target = target,
        .optimize = optimize,
        .config_addr = @intFromPtr(&config), // TODO: first hack
    });

    const lvgl = zlvgl_dep.artifact("lvgl");

    const exe = b.addExecutable(.{
        .name = "KlipperZcreen",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    exe.addModule("zlvgl", zlvgl_dep.module("zlvgl"));
    exe.linkLibrary(lvgl);
    try exe.include_dirs.appendSlice(lvgl.include_dirs.items); // TODO: second hack

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
