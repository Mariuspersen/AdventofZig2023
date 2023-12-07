const std = @import("std");
const ascii = std.ascii;

pub fn solve(text: []u8, allocator: std.mem.Allocator) !i64 {
    var number_list = std.ArrayList(i64).init(allocator);
    defer number_list.deinit();

    var count_numbers: u64 = 0;
    var first_digit: u8 = 0;
    var last_digit: u8 = 0;
    var sum: i64 = 0;

    for (text) |char| {
        if (ascii.isDigit(char)) {
            if (count_numbers == 0) {
                first_digit = try std.fmt.charToDigit(char, 10);
            }
            else {
                last_digit = try std.fmt.charToDigit(char, 10);
            }
            count_numbers += 1;
        }
        if(ascii.isWhitespace(char)) {
            if(count_numbers == 1) {
                try number_list.append((first_digit*10)+first_digit);
            } 
            else {
                try number_list.append((first_digit*10)+last_digit);
            }
            count_numbers = 0;

        }
    }

    for (number_list.items) |number| {
        sum = sum + number;
    }

    return sum;
}