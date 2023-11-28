const std = @import("std");
const glfw = @import("mach-glfw");
const gl = @import("gl");

// Engine constants
const version = "0.0.1";

const WINDOW_WIDTH = 800;
const WINDOW_HEIGHT = 600;

// Getting OpenGL proc address
fn glGetProcAddress(p: glfw.GLProc, proc: [:0]const u8) ?gl.FunctionPointer {
    _ = p;
    return glfw.getProcAddress(proc);
}

// Default GLFW error handling callback
fn errorCallback(error_code: glfw.ErrorCode, description: [:0]const u8) void {
    std.log.err("GLFW Error: {} -> {s}\n", .{ error_code, description });
}

// Default GLFW framebuffer resize callback
fn framebufferResizeCallback(window: glfw.Window, width: u32, height: u32) void {
    _ = window;
    var c_int_width: c_int = @intCast(width);
    var c_int_height: c_int = @intCast(height);
    // std.debug.print("Framebuffer resized to: {}x{}\n", .{ width, height });
    // gl.viewport(0, 0, @as(c_int, width), @as(c_int, height));
    gl.viewport(0, 0, c_int_width, c_int_height);
}

pub fn main() !void {
    // Entry - exit message
    std.debug.print("Shipment engine version: {s}\n", .{version});
    defer std.debug.print("Shipment engine exiting!\n", .{});

    // Setting callback
    glfw.setErrorCallback(errorCallback);
    // glfw.setFramebufferSizeCallback(framebufferResizeCallback);

    // Glfw initialization
    if (!glfw.init(.{})) {
        std.log.err("Failed to initialize GLFW: {?s}", .{glfw.getErrorString()});
        std.process.exit(1);
    }
    defer glfw.terminate();

    // Creating window
    const window = glfw.Window.create(WINDOW_WIDTH, WINDOW_HEIGHT, "Shipment Engine", null, null, .{}) orelse {
        std.log.err("Failed to create GLFW window: {?s}", .{glfw.getErrorString()});
        std.process.exit(1);
    };
    defer window.destroy();

    glfw.makeContextCurrent(window);

    const proc: glfw.GLProc = undefined;
    try gl.load(proc, glGetProcAddress);

    // Setting framebuffer resize callback
    window.setFramebufferSizeCallback(framebufferResizeCallback);

    // Wait for the window to close
    while (!window.shouldClose()) {
        // Main engine loop
        glfw.pollEvents();

        // Refresh screen
        gl.clearColor(0.2, 0.3, 0.3, 1.0);
        gl.clear(gl.COLOR_BUFFER_BIT);

        // Final render step - swap buffers
        window.swapBuffers();
    }
}
