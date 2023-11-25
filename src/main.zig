const std = @import("std");
const glfw = @import("mach-glfw");

// Engine constants
const version = "0.0.1";

const WINDOW_WIDTH = 800;
const WINDOW_HEIGHT = 600;

// Default GLFW error handling callback
fn errorCallback(error_code: glfw.ErrorCode, description: [:0]const u8) void {
    std.log.err("GLFW Error: {} -> {s}\n", .{ error_code, description });
}

// Default GLFW framebuffer resize callback
fn framebufferResizeCallback(window: glfw.Window, width: u32, height: u32) void {
    _ = window;
    _ = width;
    _ = height;
    // glfw.glViewport(0, 0, width, height);
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

    // Setting framebuffer resize callback
    window.setFramebufferSizeCallback(framebufferResizeCallback);

    // Wait for the window to close
    while (!window.shouldClose()) {
        // Main engine loop
        glfw.pollEvents();

        // Refresh screen

        // Final render step - swap buffers
        window.swapBuffers();
    }
}
