const std = @import("std");
const day1 = @import("day1.zig");
const day1_1 = @import("day1_1.zig");
const day2 = @import("day2.zig");
const day3 = @import("day3.zig");


pub fn main() !void {

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    defer bw.flush() catch {};

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var args = try std.process.ArgIterator.initWithAllocator(allocator);
    _ = args.next();
    defer args.deinit();

    if (args.next()) |value| {
        const file = try std.fs.cwd().openFile(value, .{ .mode = .read_only });
        const stat = try file.stat();
        const text = try file.readToEndAlloc(allocator, stat.size);
        defer allocator.free(text);

        //var result = try day1.solve(text, allocator);
        //try stdout.print("Day 1 Result: {d}\n", .{result});

        //result = try day1_1.solve(text, allocator);
        //try stdout.print("Day 1-1 Result: {d}\n", .{result});

        //var result_day2 = try day2.solve(text, allocator);
        //try stdout.print("Day 2 Result: {d}\tDay 2-2 Result: {d}\n", .{result_day2[0],result_day2[1]});

        var result_day3 = try day3.solve(text, allocator);
        try stdout.print("Day 3 Result: {d}\tDay 3-2 Result: {d}\n", .{result_day3[0],result_day3[1]});
    }

}
