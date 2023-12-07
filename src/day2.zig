const std = @import("std");

const Subset = struct {
    red: u64 = 0,
    green: u64 = 0,
    blue: u64 = 0,

    pub fn init(subset: []const u8) !Subset {
        var self: Subset = Subset{};
        var split_colors = std.mem.split(u8, subset, ",");
        var current_number: u64 = 0;
        var last_digit_index: usize = 0;

        while (split_colors.next()) |color| {
            for (color, 1..) |char, i| {
                if (std.ascii.isDigit(char)) {
                    last_digit_index = i;
                }
            }
            current_number = try std.fmt.parseInt(u64, color[1..last_digit_index], 10);
            if (std.mem.lastIndexOf(u8, color, "red")) |_| {
                self.red = current_number;
            }
            if (std.mem.lastIndexOf(u8, color, "green")) |_| {
                self.green = current_number;
            }
            if (std.mem.lastIndexOf(u8, color, "blue")) |_| {
                self.blue = current_number;
            }
        }
        return self;
    }
};

const Game = struct {
    id: usize,
    subsets: std.ArrayList(Subset),

    pub fn init(game: []const u8, allocator: std.mem.Allocator) !Game {
        var self: Game = undefined;

        var id_split = std.mem.split(u8, game, ":");
        const id = id_split.first()[5..];
        self.id = try std.fmt.parseInt(usize, id, 10);
        self.subsets = std.ArrayList(Subset).init(allocator);

        if (id_split.next()) |reveals| {
            var split_subsets = std.mem.split(u8, reveals, ";");

            while (split_subsets.next()) |colors| {
                var color_collection = try Subset.init(colors);
                try self.subsets.append(color_collection);
            }
        }
        return self;
    }

    pub fn deinit(self: *Game) void {
        self.subsets.deinit();
    }
};

pub fn solve(text: []u8, allocator: std.mem.Allocator) ![2]usize {
    var possible_games = std.ArrayList(usize).init(allocator);
    var powers_of_cubes = std.ArrayList(u64).init(allocator);
    defer possible_games.deinit();
    defer powers_of_cubes.deinit();

    var sum: usize = 0;
    var sum_powers: usize = 0;

    const max_red_cubes = 12;
    const max_green_cubes = 13;
    const max_blue_cubes = 14;

    var lines = std.mem.split(u8, text, "\n");
    while (lines.next()) |line| {
        var possible: bool = true;
        var game = try Game.init(line, allocator);
        defer game.deinit();

        var min_red_cubes: u64 = 0;
        var min_green_cubes: u64 = 0;
        var min_blue_cubes: u64 = 0;

        for (game.subsets.items) |subset| {
            if (possible) {
                possible = subset.red <= max_red_cubes and subset.green <= max_green_cubes and subset.blue <= max_blue_cubes;
            }

            if (subset.red > min_red_cubes) {
                min_red_cubes = subset.red;
            }
            if (subset.green > min_green_cubes) {
                min_green_cubes = subset.green;
            }
            if (subset.blue > min_blue_cubes) {
                min_blue_cubes = subset.blue;
            }
        }

        try powers_of_cubes.append(min_red_cubes * min_green_cubes * min_blue_cubes);
        
        if (possible) {
            try possible_games.append(game.id);
        }
    }

    for (possible_games.items) |number| {
        sum = sum + number;
    }

    for (powers_of_cubes.items) |number| {
        sum_powers = sum_powers + number;
    }

    return [2]usize{sum,sum_powers};
}
