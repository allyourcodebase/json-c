const std = @import("std");

const version = .{ .major = 0, .minor = 18 };

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("upstream", .{ .target = target, .optimize = optimize });

    const config = b.addConfigHeader(
        .{
            .style = .{ .cmake = upstream.path("cmake/config.h.in") },
            .include_path = "config.h",
        },
        cmake_config,
    );
    const json_config = b.addConfigHeader(
        .{
            .style = .{ .cmake = upstream.path("cmake/json_config.h.in") },
            .include_path = "json_config.h",
        },
        .{
            .JSON_C_HAVE_INTTYPES_H = 1,
            .JSON_C_HAVE_STDINT_H = 1,
        },
    );
    const json = b.addConfigHeader(
        .{
            .style = .{ .cmake = upstream.path("json.h.cmakein") },
            .include_path = "json.h",
        },
        .{
            .JSON_H_JSON_PATCH =
            \\#include "json_patch.h"
            ,
            .JSON_H_JSON_POINTER =
            \\#include "json_pointer.h"
            ,
        },
    );

    const lib = b.addStaticLibrary(.{
        .name = "json-c",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    lib.addIncludePath(upstream.path(""));
    lib.addConfigHeader(config);
    lib.addConfigHeader(json_config);
    lib.addConfigHeader(json);
    lib.installHeader(json_config.getOutput(), "json-c/json_config.h");
    lib.installHeader(json.getOutput(), "json-c/json.h");
    lib.root_module.addCMacro("_GNU_SOURCE", "1");
    lib.addCSourceFiles(.{
        .root = upstream.path(""),
        .files = &source_files,
        .flags = &CFLAGS,
    });
    lib.installHeadersDirectory(
        upstream.path("./"),
        "json-c",
        .{ .include_extensions = &public_headers },
    );
    b.installArtifact(lib);
}

const source_files = .{
    "arraylist.c",
    "debug.c",
    "json_c_version.c",
    "json_object.c",
    "json_object_iterator.c",
    "json_patch.c",
    "json_pointer.c",
    "json_tokener.c",
    "json_util.c",
    "json_visit.c",
    "libjson.c",
    "linkhash.c",
    "printbuf.c",
    "random_seed.c",
    "strerror_override.c",
};

const public_headers = .{
    "arraylist.h",
    "debug.h",
    "json_c_version.h",
    "json_inttypes.h",
    "json_object.h",
    "json_object_iterator.h",
    "json_patch.h",
    "json_pointer.h",
    "json_tokener.h",
    "json_types.h",
    "json_util.h",
    "json_visit.h",
    "linkhash.h",
    "printbuf.h",
};

const CFLAGS = .{
    "-Wall",
    "-Wextra",
    "-Wcast-qual",
    "-Wwrite-strings",
    "-Wmissing-declarations",
    "-Wold-style-definition",
    "-Wstrict-prototypes",
    "-Werror",
    "-Wno-unused-parameter",
};

const cmake_config = .{
    .HAVE_DLFCN_H = 1,
    .HAVE_ENDIAN_H = 1,
    .HAVE_FCNTL_H = 1,
    .HAVE_INTTYPES_H = 1,
    .HAVE_LIMITS_H = 1,
    .HAVE_LOCALE_H = 1,
    .HAVE_MEMORY_H = 1,
    .HAVE_STDARG_H = 1,
    .HAVE_STDINT_H = 1,
    .HAVE_STDLIB_H = 1,
    .HAVE_STRINGS_H = 1,
    .HAVE_STRING_H = 1,
    .HAVE_SYSLOG_H = 1,
    .HAVE_SYS_CDEFS_H = 1,
    .HAVE_SYS_PARAM_H = 1,
    .HAVE_SYS_RANDOM_H = 1,
    .HAVE_SYS_RESOURCE_H = 1,
    .HAVE_SYS_STAT_H = 1,
    .HAVE_SYS_TYPES_H = 1,
    .HAVE_UNISTD_H = 1,
    .HAVE_ATOMIC_BUILTINS = 1,
    .HAVE_DECL_INFINITY = 1,
    .HAVE_DECL_ISINF = 1,
    .HAVE_DECL_ISNAN = 1,
    .HAVE_DECL_NAN = 1,
    .HAVE_OPEN = 1,
    .HAVE_REALLOC = 1,
    .HAVE_SETLOCALE = 1,
    .HAVE_SNPRINTF = 1,
    .HAVE_STRCASECMP = 1,
    .HAVE_STRDUP = 1,
    .HAVE_STRERROR = 1,
    .HAVE_STRNCASECMP = 1,
    .HAVE_USELOCALE = 1,
    .HAVE_VASPRINTF = 1,
    .HAVE_VPRINTF = 1,
    .HAVE_VSNPRINTF = 1,
    .HAVE_VSYSLOG = 1,
    .HAVE_GETRANDOM = 1,
    .HAVE_GETRUSAGE = 1,
    .HAVE_STRTOLL = 1,
    .HAVE_STRTOULL = 1,
    .HAVE___THREAD = 1,
    .JSON_C_HAVE_INTTYPES_H = 1,
    .SIZEOF_INT = @sizeOf(c_int),
    .SIZEOF_INT64_T = @sizeOf(i64),
    .SIZEOF_LONG = @sizeOf(c_long),
    .SIZEOF_LONG_LONG = @sizeOf(c_longlong),
    .SIZEOF_SIZE_T = @sizeOf(usize),
    .SIZEOF_SSIZE_T = @sizeOf(isize),
    .SPEC___THREAD = "__thread",
    .STDC_HEADERS = 1,

    .json_c_strtoll = null,
    .json_c_strtoull = null,
    .PROJECT_NAME = "json-c",
    .JSON_C_BUGREPORT = "json-c@googlegroups.com",
    .CPACK_PACKAGE_VERSION_MAJOR = version.major,
    .CPACK_PACKAGE_VERSION_MINOR = version.minor,
    .CPACK_PACKAGE_VERSION_PATCH = 0,
    .ENABLE_RDRAND = null,
    .OVERRIDE_GET_RANDOM_SEED = null,
};
