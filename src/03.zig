//
// It's a fucking mess.
//
const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const print = std.debug.print;
const ArrayList = std.ArrayList;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

const data = @embedFile("../inputs/day_03");

const StuffToReach = enum {
    OxygenGenerator,
    CO2Scruber,
};

pub fn main() !void {
    var gammaRate: [12]u8 = mem.zeroes([12]u8);
    var epsilonRate: [12]u8 = mem.zeroes([12]u8);

    var lines = ArrayList([]const u8).init(&gpa.allocator);
    defer lines.deinit();

    var iter = mem.tokenize(u8, data, "\n");
    while (iter.next()) |line| try lines.append(line);

    var currentBit: usize = 0;
    while (currentBit < 12) : (currentBit += 1) {
        var numberOf_0: i32 = 0;
        var numberOf_1: i32 = 0;

        for (lines.items) |row, index| {
            const digit = try fmt.charToDigit(row[currentBit], 10);

            if (digit == 0) {
                numberOf_0 += 1;
            } else {
                numberOf_1 += 1;
            }
        }

        if (numberOf_0 > numberOf_1) {
            gammaRate[currentBit] = '0';
            epsilonRate[currentBit] = '1';
        } else {
            gammaRate[currentBit] = '1';
            epsilonRate[currentBit] = '0';
        }
    }

    const gammaRateInt = try fmt.parseInt(i32, &gammaRate, 2);
    const epsilonRateInt = try fmt.parseInt(i32, &epsilonRate, 2);

    const oxygenRating = try cmp(lines.items, 0, .OxygenGenerator);
    const co2Rating = try cmp(lines.items, 0, .CO2Scruber);

    print("PART 1: {}\n", .{gammaRateInt * epsilonRateInt});
    print("PART 2: {}\n", .{oxygenRating * co2Rating});
}

fn cmp(mainData: [][]const u8, currentBit: usize, stuffToReach: StuffToReach) !i32 {
    var currentBucket = ArrayList([]const u8).init(&gpa.allocator);
    defer currentBucket.deinit();

    var numberOf_0: i32 = 0;
    var numberOf_1: i32 = 0;

    for (mainData) |row, index| {
        const digit = try fmt.charToDigit(row[currentBit], 10);

        if (digit == 0) {
            numberOf_0 += 1;
        } else {
            numberOf_1 += 1;
        }
    }

    if (numberOf_0 == numberOf_1) {
        if (stuffToReach == .OxygenGenerator) {
            for (mainData) |row| {
                if (row[currentBit] == '1') {
                    try currentBucket.append(row);
                }
            }
        } else {
            for (mainData) |row| {
                if (row[currentBit] == '0') {
                    try currentBucket.append(row);
                }
            }
        }
    } else {
        if (stuffToReach == .OxygenGenerator) {
            if (numberOf_0 > numberOf_1) {
                for (mainData) |row| {
                    if (row[currentBit] == '0') {
                        try currentBucket.append(row);
                    }
                }
            } else {
                for (mainData) |row| {
                    if (row[currentBit] == '1') {
                        try currentBucket.append(row);
                    }
                }
            }
        } else {
            if (numberOf_0 > numberOf_1) {
                for (mainData) |row| {
                    if (row[currentBit] == '1') {
                        try currentBucket.append(row);
                    }
                }
            } else {
                for (mainData) |row| {
                    if (row[currentBit] == '0') {
                        try currentBucket.append(row);
                    }
                }
            }
        }
    }

    if (currentBucket.items.len == 1) {
        return try fmt.parseInt(i32, currentBucket.items[0], 2);
    }

    return cmp(currentBucket.items, currentBit + 1, stuffToReach);
}
