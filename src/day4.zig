const std = @import("std");
const mem = std.mem;
const ascii = std.ascii;
const fmt = std.fmt;

const Scratchcard = struct {
    id: usize,
    matching: usize,
};

pub fn solve(text: []u8, allocator: mem.Allocator) !void {
    var scores = std.ArrayList(usize).init(allocator);
    var cards = std.ArrayList(usize).init(allocator);

    defer scores.deinit();
    defer cards.deinit();
    
    var lines = mem.split(u8, text, "\n");
    var total_lines: usize = 1;
    while (lines.next()) |line| : (total_lines += 1) {
        var id_split = mem.split(u8, line, ":");

        var id = if(id_split.next()) |game_id| mem.trim(u8,game_id[4..]," ") else error.parsing_error;
        _ = try id;
        var all_numbers = if(id_split.next()) |all_numbers| all_numbers else error.parsing_error;

        var split_numbers = mem.split(u8, try all_numbers, "|");

        var winning_numbers = if(split_numbers.next()) |num| mem.trim(u8, num, " ") else error.parsing_error;
        var player_numbers = if(split_numbers.next()) |num| mem.trim(u8, num, " ") else error.parsing_error;

        var winning_numbers_split = mem.split(u8, try winning_numbers, " ");
        var player_numbers_split = mem.split(u8, try player_numbers, " ");

        var points: usize = 0;
        var matches: usize = 0;

        //std.debug.print("GAME: {s}\n", .{try id});
        while (winning_numbers_split.next()) |winning_number| {
            defer player_numbers_split.reset();

            if (mem.eql(u8, winning_number, "")) {
                continue;
            }

            //std.debug.print("\tWINNER: *{s}*\n", .{winning_number});
            while (player_numbers_split.next()) |player_number| {
                if (mem.eql(u8, player_number, "")) {
                    continue;
                }

                if(mem.eql(u8, winning_number, player_number)) {
                    if (points == 0) points += 1 else points *= 2;
                    matches += 1;

                    //std.debug.print("\t\tPLAYING: {s}\n", .{player_number});
                }
            }
        }
        //std.debug.print("GAME SCORE: {d}\n", .{points});
        try cards.append(matches);
        try scores.append(points);
    }

    var sum: usize = 0;
    for (scores.items) |score| {
        sum += score;
    }

    var sum_cards: usize = total_lines;
    for (cards.items) |card| {
        sum_cards += card;
    }

    return [2]usize{sum,sum_cards};
}
