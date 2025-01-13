# Data Visualization with Zig

This project demonstrates how to create a simple line plot using Zig. The plot is rendered as an SVG file.

## Features

- Dynamically scales data for plotting.
- Generates an SVG file with clean rendering.
- Supports custom dimensions and titles.

## How to Run

1. **Compile the project**:
   ```bash
   zig build-exe main.zig
   ```

2. **Run the executable**:
   ```bash
   ./main
   ```

3. **Check the output**:
   - The generated plot will be saved as `output.svg`.

4. **View the SVG**:
   - Open the `output.svg` file in your browser or an SVG viewer.

## Example Output

An example SVG output will look like this:

```svg
<svg width="800" height="600" xmlns="http://www.w3.org/2000/svg">
  <rect width="100%" height="100%" fill="white"/>
  <polyline points="50.00,50.00 200.00,200.00 400.00,400.00" stroke="black" fill="none"/>
</svg>
```

## License

This project is licensed under the MIT License.
