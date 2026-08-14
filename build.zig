const std = @import("std");
const microzig = @import("microzig");

// Enable the ports the firmware targets need. Adding a chip family later
// means flipping its port on here and picking a target from `mb.ports`.
const MicroBuild = microzig.MicroBuild(.{ .rp2xxx = true });

pub fn build(b: *std.Build) void {
    const host_target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // register the flag so `-Denable-coverage=true` is valid
    _ = b.option(bool, "enable-coverage", "Enable coverage instrumentation") orelse false;

    // The core module holds the hardware-free logic. Its tests run on the
    // host, so `zig build test` needs no board attached.
    const test_step = b.step("test", "Run the unit tests on the host");

    {
        const core_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path("src/core/core.zig"),
                .target = host_target,
                .optimize = optimize,
            }),
        });
        const core_run = b.addRunArtifact(core_tests);
        test_step.dependOn(&core_run.step);
        const core_install = b.addInstallArtifact(core_tests, .{ .dest_sub_path = "test-root" });
        test_step.dependOn(&core_install.step);
    }

    {
        const core_mod = b.createModule(.{
            .root_source_file = b.path("src/core/core.zig"),
            .target = host_target,
            .optimize = optimize,
        });
        const ext_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path("tests/main.zig"),
                .target = host_target,
                .optimize = optimize,
                .imports = &.{.{ .name = "core", .module = core_mod }},
            }),
        });
        const ext_run = b.addRunArtifact(ext_tests);
        test_step.dependOn(&ext_run.step);
        const ext_install = b.addInstallArtifact(ext_tests, .{ .dest_sub_path = "test-ext" });
        test_step.dependOn(&ext_install.step);
    }

    // The firmware. MicroZig provides the startup code, the linker script,
    // and the HAL; the core module is imported into it unchanged.
    const mz_dep = b.dependency("microzig", .{});
    const mb = MicroBuild.init(b, mz_dep) orelse return;

    const fw_core = b.createModule(.{
        .root_source_file = b.path("src/core/core.zig"),
    });
    const firmware = mb.add_firmware(.{
        .name = "blinky",
        .target = mb.ports.rp2xxx.boards.raspberrypi.pico2_arm,
        .optimize = optimize,
        .root_source_file = b.path("src/firmware/main.zig"),
        .imports = &.{.{ .name = "core", .module = fw_core }},
    });
    // Installs both the ELF (for debugging) and the UF2 (for flashing) into `zig-out/firmware/`.
    mb.install_firmware(firmware, .{});
}
