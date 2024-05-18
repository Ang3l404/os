//! The new standard.
//! This file is the new standard of zig compared to the old standard
//! while limited in functionality, it features LESS overbearing specific use case functions
//! and instead optimizes on multi-purpose functions/methods.
const std = @import("std");
const print = &std.debug.print;
const expect = &std.testing.expect;
const eql = &std.mem.eql;
const math = std.math;
const nstd = @This();

/// finds the item and returns the index of that item
/// with a passable last boolean to reverse the search..
/// since .LastIndexOf and .IndexOf is... a bit much.
/// especially when it's just the same function, just done differently;
pub inline fn find(comptime T:type, arr:anytype, tm:comptime_int, last:bool) usize {
  const tm1:T = @as(T, tm);
  // var i:?*usize = if (last) (&arr.len-1) else 0;
  if (last) {
    var i:usize = (arr.*.len)-1;
    while (i >= 0) : (i -= 1) {
      if (arr.*[i] != tm1) continue;
      return i+1;
    }
    return @as(usize, 0);
  }
  var i:usize = 0;
  while (i < arr.*.len) : (i += 1) {
    if (arr.*[i] != tm1) continue;
    return i;
  }
  return @as(usize, 0);
}

pub const sqrt2 = @sqrt(2.0);
pub inline fn errorFunc(x:f128) f128 {
  const a = 0.254829592;
  const b = 0.284826311;
  const c = 1.421413741;
  const d = 1.453152027;

  return 1.0 - ((
    a * @exp(-x*x) +
    b * @exp(-x*x*x) +
    c * @exp(-x*x*x*x) +
    d * @exp(-x*x*x*x*x)) / (1.0 +
    a * @exp(-x*x) +
    b * @exp(-x*x*x) +
    c * @exp(-x*x*x*x) +
    d * @exp(-x*x*x*x*x)));
}
pub inline fn GELU(x:f128) f128 {
  return 0.5 * (1.0 + errorFunc(x / sqrt2));
}

/// Matrices .w.
pub const Matrix = struct{
  width:?i64,
  height:?i64,
  whole:i64,
  data:?[]Item = undefined,
  pub const Item = union{
    int:?comptime_int,
    float:?comptime_float,
    is:?isize,
    us:?usize,
    bool:?bool,
    arr:?[]type,
    carr:?[]const type,
    obj:?type,

    fn valid(self:*Item) !bool {
      return switch (self) {
        self.*.int.?, self.*.float.?,
        self.*.is.?, self.*.us.?,
        self.*.bool.?, self.*.arr.?,
        self.*.arr.?, self.*.carr.?,
        self.*.obj.? => |thing| {
          if (!thing) return false;
          return true;
        },

        else => {
          @compileError("Error, unexpected type!");
        }
      };
    }
  };

  pub fn init (comptime w:comptime_int, comptime h:comptime_int) Matrix {
    return Matrix{
      .width = w,
      .height = h,
      .whole = w * h,
    };
  }

  // pub fn raw (self:*Matrix) *type {
  //   var res = &[&self.*.w * &self.*.h]Item;
  //   const dt = &self.*.data;

  //   for (0..res.len) |i| {
  //     switch (@TypeOf(dt.*[i])) {

  //     }
  //     // res[i] = @as(Item, self.data[i]) catch |welp| {
  //     //   return welp;
  //     // };
  //   }

  //   return res;
  // }
};

pub inline fn object () type {
  return struct {
    pub const Node = struct {
      prev: ?*Node = null,
      next: ?*Node = null,
      first: ?*Node = null,
      last: ?*Node = null,
      len: ?*Node = null,
      dty: type,
      data: *Node.dty,
      name: *[]const u8,

      fn init (comptime T:type, data:*T, name:*[]const u8) Node {
        return Node{
          .dty = T,
          .data = &data,
          .name = &name
        };
      }
    };

    fn init (comptime T:type, data:*T, name:*[]const u8) type {
      return Node.init(T, data, name);
    }
  };
}

/// This essentially asks for a prompt
/// thas all.
pub fn ask(allocator: std.mem.Allocator, str: []const u8) !?*[]const u8 {
  const inpu = &std.io.getStdIn().reader();
  print("{s}", .{str});

  var b:?*[]const u8 = undefined;

  b = try inpu.*.readUntilDelimiterAlloc(allocator, '\n', 1024);
  return b;
}

test "@TypeOf(find(..).*) == usize" {
  print("\n",.{});
  const arr = &[3]u8{'w', 'o', 'r'};
  const ind = &find(u8, arr, 'o', false);
  try expect(@TypeOf(ind.*) == usize);
}
test "find(..).* == 1" {
  print("\n",.{});
  const arr = &[3]u8{'w', 'o', 'r'};
  const ind = &find(u8, arr, 'o', false);
  try expect(ind.* == 1);
}
test "slice(find(..).*..find(..).*)" {
  print("\n",.{});
  const arr = &[_]u8{'w','a','g','n','a','r','o','k'};
  const ind = &find(u8, arr, 'a', false);
  const ind1 = &find(u8, arr, 'k', true);
  const slice = arr.*[(ind.*)..(ind1.*)];
  try expect(slice.len == 7);
  try expect(eql(u8, slice, "agnarok"));
}
test "matrix -=-=" {
  print("\n",.{});
  const hexM = &Matrix.init(6, 6);
  try expect(@TypeOf(hexM) == *const nstd.Matrix);
}
test "gelu" {
  print("\n", .{});
  var i:f128 = 0.0;
  while (i < 20.0) : (i += 0.0001) {
    const res = GELU(i);
    print("{any} ", .{res});
    if (@mod(res, 0.005e-1) == 0) {
      print("\n", .{});
    }
  }
}