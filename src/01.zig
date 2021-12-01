const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const print = std.debug.print;
const ArrayList = std.ArrayList;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

const data = @embedFile("../inputs/day_01");

pub fn main() !void {
    var numbers = ArrayList(i32).init(&gpa.allocator);
    defer numbers.deinit();

    var iter = mem.tokenize(u8, data, "\n");
    while (iter.next()) |line| try numbers.append(try fmt.parseInt(i32, line, 0));

    var sums = ArrayList(i32).init(&gpa.allocator);
    defer sums.deinit();

    for (numbers.items) |number, index| {
        if (index >= numbers.items.len - 2) continue;

        const a = number;
        const b = numbers.items[index + 1];
        const c = numbers.items[index + 2];

        try sums.append(a + b + c);
    }

    print("PART 1: {}\n", .{countIncreased(numbers.items)});
    print("PART 2: {}\n", .{countIncreased(sums.items)});
}

fn countIncreased(numbers: []const i32) i32 {
    var count: i32 = 0;

    for (numbers) |number, index| {
        if (index == 0) continue;

        const currentNumber = number;
        const prevNumber = numbers[index - 1];

        if (currentNumber > prevNumber) count += 1;
    }

    return count;
}
