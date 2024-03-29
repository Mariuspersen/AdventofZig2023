const std = @import("std");
const ascii = std.ascii;

const Partnumber = struct {
    start_index: usize,
    end_index: usize,
    line: usize,
    value: u64,
    checked: bool,

    pub fn init(start_idx: usize, end_idx: usize, line: usize, value: u64) !Partnumber {
        return Partnumber{
            .start_index = start_idx,
            .end_index = end_idx,
            .line = line,
            .value = value,
            .checked = false,
        };
    }
};

const Symbol = struct {
    index: usize,
    line: usize,
    char: u8,

    pub fn init(line_number: usize, idx: usize, char: u8) Symbol {
        return Symbol {
            .index = idx,
            .line = line_number,
            .char = char,
        };
    }
};

pub fn solve(text: []u8, allocator: std.mem.Allocator) ![2]usize {
    var partnumbers = std.ArrayList(Partnumber).init(allocator);
    var valid = std.ArrayList(u64).init(allocator);
    var symbols = std.ArrayList(Symbol).init(allocator);
    var gears = std.ArrayList(usize).init(allocator);
    defer partnumbers.deinit();
    defer valid.deinit();
    defer symbols.deinit();
    defer gears.deinit();

    var lines = std.mem.split(u8, text, "\n");
    var line_count: usize = 0;

    var reading_digit: bool = false;
    var first_digit_idx: usize = 0;
    var last_digit_idx: usize = 0;

    var sum: usize = 0;
    var sum_gears: usize = 0;

    while (lines.next()) |line| : (line_count += 1) {
        for (line, 0..) |char, idx| {

            if (char != '.' and !ascii.isDigit(char)) {
                try symbols.append(Symbol.init(line_count, idx, char));
            }

            if (ascii.isDigit(char)) {
                if (!reading_digit) {
                    reading_digit = true;
                    first_digit_idx = idx;
                }
            }

            if ((!ascii.isDigit(char) and reading_digit) or (ascii.isDigit(char) and line.len - 1 == idx)) {
                var offset: usize = if(ascii.isDigit(char) and line.len - 1 == idx) 1 else 0;
                reading_digit = false;
                last_digit_idx = idx + offset;
                try partnumbers.append(try Partnumber.init(first_digit_idx, last_digit_idx, line_count, try std.fmt.parseInt(u64, line[first_digit_idx..last_digit_idx], 10)));
            }
        }
    }

    for (symbols.items) |symbol| {
        var temp_gear = std.ArrayList(usize).init(allocator);
        defer temp_gear.deinit();

        for (symbol.index..symbol.index+2) |x| {
            for (if(symbol.line == 0) 0 else (symbol.line - 1)..(symbol.line+2)) |y| {
                for (partnumbers.items,0..) |partnumber,i| {
                    if (partnumber.start_index <= x and partnumber.end_index >= x and partnumber.line == y and !partnumber.checked) {
                        if (symbol.char == '*') {
                            try temp_gear.append(partnumber.value);
                        }

                        partnumbers.items[i].checked = true;
                        try valid.append(partnumber.value);
                    }
                }
            }
        }

        if (temp_gear.items.len == 2) {
            try gears.append(temp_gear.items[0] * temp_gear.items[1]);
        }

    }

    for (valid.items) |number| {
        sum = sum + number;
    }

    for (gears.items) |number| {
        sum_gears = sum_gears + number;
    }

    return [2]usize{sum,sum_gears};
}
