const std = @import("std");

pub fn scaleData(data: []const f64, min: f64, max: f64) ![]f64 {
    const allocator = std.heap.page_allocator;

    const data_min = try findMin(data);
    const data_max = try findMax(data);

    const scaled = try allocator.alloc(f64, data.len);
    var idx: usize = 0;
    for (data) |value| {
        scaled[idx] = min + (value - data_min) / (data_max - data_min) * (max - min);
        idx += 1;
    }

    return scaled;
}

fn findMin(data: []const f64) !f64 {
    if (data.len == 0) return error.EmptyData;
    var min = data[0];
    for (data[1..]) |value| {
        if (value < min) {
            min = value;
        }
    }
    return min;
}

fn findMax(data: []const f64) !f64 {
    if (data.len == 0) return error.EmptyData;
    var max = data[0];
    for (data[1..]) |value| {
        if (value > max) {
            max = value;
        }
    }
    return max;
}
