const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();

    {
        var exe = b.addExecutable("adventofcode_2021", "src/03.zig");
        exe.install();

        const play = b.step("run", "Run current puzzle");
        const run = exe.run();
        run.step.dependOn(b.getInstallStep());

        play.dependOn(&run.step);
    }
}
