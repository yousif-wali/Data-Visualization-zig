const std = @import("std");
const Plot = @import("plot.zig").Plot;

pub fn main() !void {
    var allocator = std.heap.page_allocator; // Declare the allocator as a variable

    // Create a plot and pass the pointer to the allocator
    var plot = Plot.init(&allocator, "Line Plot", 800, 600);
    defer plot.deinit();

    // Example data
    const x_data = [_]f64{ 0.0, 2.0, 3.0, 3.0, 6.0 };
    const y_data = [_]f64{ 0.0, 2.0, 4.0, 6.0, 10.0 };

    // Add data to the plot
    try plot.addLine(x_data[0..], y_data[0..]);

    // Save the plot to an SVG file
    const output_path = "output.svg";
    try plot.save(output_path);

    std.debug.print("Plot saved to {s}\n", .{output_path});
}
