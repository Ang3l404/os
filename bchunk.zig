const std = @import("std");
const nstd = @import("./../nstd.zig");
const fmt = &std.fmt;
const track_t = struct {
  num: i8,
  mode: i8,
  audio: i8,
  modes: []i8,
};