const std = @import("std");
const utils = @import("utils.zig");

pub const Plot = struct {
    title: []const u8,
    width: usize,
    height: usize,
    allocator: *std.mem.Allocator,
    buffer: []u8,

    pub fn init(allocator: *std.mem.Allocator, title: []const u8, width: usize, height: usize) Plot {
        return Plot{
            .title = title,
            .width = width,
            .height = height,
            .allocator = allocator,
            .buffer = &[_]u8{},
        };
    }

    pub fn deinit(self: *Plot) void {
        if (self.buffer.len > 0) {
            self.allocator.free(self.buffer);
        }
    }

    pub fn addLine(self: *Plot, x_data: []const f64, y_data: []const f64) !void {
        if (x_data.len != y_data.len) return error.MismatchedLengths;

        const scaled_x = try utils.scaleData(x_data, 50.0, @floatFromInt(self.width - 50));
        const scaled_y = try utils.scaleData(y_data, 50.0, @floatFromInt(self.height - 50));

        // Dynamically construct points string
        var points_builder = std.ArrayList(u8).init(self.allocator.*);
        defer points_builder.deinit();

        var idx: usize = 0;
        for (scaled_x) |x| {
            const y = scaled_y[idx];
            const point_str = try std.fmt.allocPrint(self.allocator.*, "{:.2},{:.2} ", .{ x, y });
            defer self.allocator.free(point_str);

            try points_builder.appendSlice(point_str);
            idx += 1;
        }

        const points_slice = points_builder.items;

        // Final SVG construction
        const svg_template =
            "<svg width=\"{d}\" height=\"{d}\" xmlns=\"http://www.w3.org/2000/svg\">\n" ++
            "  <rect width=\"100%\" height=\"100%\" fill=\"white\"/>\n" ++
            "  <polyline points=\"{s}\" stroke=\"black\" fill=\"none\"/>\n" ++
            "</svg>";

        const total_size = svg_template.len + points_slice.len;
        self.buffer = try self.allocator.alloc(u8, total_size);

        const final_buffer = try std.fmt.bufPrint(self.buffer, svg_template, .{ self.width, self.height, points_slice });
        if (final_buffer.len > self.buffer.len) {
            return error.OutOfMemory; // Handle unexpected overflow
        }
    }

    pub fn save(self: *Plot, path: []const u8) !void {
        var file = try std.fs.cwd().createFile(path, .{});
        defer file.close();

        try file.writeAll(self.buffer);
    }
};
