const std = @import("std");
const ascii = std.ascii;

const indexed_number = struct {
    index: usize,
    value: usize,
};

pub fn solve(text: []u8, allocator: std.mem.Allocator) !i64 {
    var lines = std.mem.split(u8, text, "\n");

    const numbers_as_text = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
    const numbers_as_digits = [_][]const u8{ "1", "2", "3", "4", "5", "6", "7", "8", "9" };

    var sum: i64 = 0;
    var number_list = std.ArrayList(i64).init(allocator);
    defer number_list.deinit();

    while (lines.next()) |line| {
        var line_numbers = std.ArrayList(indexed_number).init(allocator);
        defer line_numbers.deinit();

        var first_number: indexed_number = undefined;
        var last_number: indexed_number = undefined;

        for (numbers_as_text, 1..) |number, i| {
            const result = std.mem.lastIndexOf(u8, line, number);
            const result2 = std.mem.indexOf(u8, line,number);
            if (result) |index| {
                try line_numbers.append(.{ .index = index, .value = i });
            }

            if (result2) |index| {
                try line_numbers.append(.{ .index = index, .value = i });
            }
        }
        for (numbers_as_digits, 1..) |number, i| {
            const result = std.mem.lastIndexOf(u8, line, number);
            const result2 = std.mem.indexOf(u8, line,number);
            if (result) |index| {
                try line_numbers.append(.{ .index = index, .value = i });
            }
            if (result2) |index| {
                try line_numbers.append(.{ .index = index, .value = i });
            }
        }

        if (line_numbers.items.len == 0) continue;

        last_number = line_numbers.items[0];
        first_number = line_numbers.items[0];

        for (line_numbers.items) |number| {
            if (last_number.index <= number.index) last_number = number;
        }

        for (line_numbers.items) |number| {
            if (first_number.index >= number.index) first_number = number;
        }

        const first: i64 = @intCast(first_number.value);
        const last: i64 = @intCast(last_number.value);

        try number_list.append((first*10)+last);
    }

    for (number_list.items) |number| {
        sum = sum + number;
    }

    return sum;
}
