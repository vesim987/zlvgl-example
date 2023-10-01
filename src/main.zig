const std = @import("std");
const lv = @import("zlvgl");

var exit: bool = false;

pub fn main() !void {
    lv.init();
    defer lv.deinit();

    lv.drivers.init();
    defer lv.drivers.deinit();
    lv.drivers.register();

    const screen = lv.Screen.active();
    const tabview = lv.TabView.init(screen, .Left, lv.pct(10));
    defer lv.c._lv_obj_destruct(tabview.obj);
    const foo = tabview.addTab("foo");

    const btn1 = lv.Button.init(foo);
    lv.Label.init(btn1).setTextStatic("Exit");

    btn1.addEventCallback(struct {
        pub fn onClicked(target: lv.Button) void {
            _ = target;
            std.debug.print("Clicked\n", .{});
            exit = true;
        }
    });

    var lastTick: i64 = std.time.milliTimestamp();
    while (true) {
        if (exit) break;
        lv.tick.inc(@intCast(std.time.milliTimestamp() - lastTick));
        lastTick = std.time.milliTimestamp();
        lv.task.handler();
    }
}
