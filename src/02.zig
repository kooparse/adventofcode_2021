const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const print = std.debug.print;
const ArrayList = std.ArrayList;

const data = @embedFile("../inputs/day_02");

pub fn main() !void {
    var horizontalPosition: i32 = 0;
    var depth: i32 = 0;
    var fixedDepth: i32 = 0;

    var iter = mem.tokenize(u8, data, "\n");
    while (iter.next()) |line| {
        const firstChar = line[0..1];
        const value = try fmt.charToDigit(line[line.len - 1], 10);

        if (mem.eql(u8, "f", firstChar)) {
            horizontalPosition += value;
            fixedDepth += (depth * value);
        } else if (mem.eql(u8, "u", firstChar)) {
            depth -= value;
        } else {
            depth += value;
        }
    }

    print("PART 1: {}\n", .{horizontalPosition * depth});
    print("PART 1: {}\n", .{horizontalPosition * fixedDepth});
}
