//! The new standard.
const std = @import("std");
const print = &std.debug.print;
const expect = &std.testing.expect;
const eql = &std.mem.eql;

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


/// Matrices .w.
pub inline fn matrix (comptime t: type, comptime w: comptime_int, comptime h: comptime_int) type {
  return struct {
    width:?[w]t,
    height:?[h]t,

    fn init() @This() {
      return .{};
    }


  };
  // return [w][h]t;
}

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
  const hexM = matrix(i16, 5, 5);
  print("{any}\n", .{hexM});
  try expect(@TypeOf(hexM) == type);
}