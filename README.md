# `build.zig` for json-c

Provides a package to be used by the zig package manager for C programs.

## Status

For now the hard-coded config assumes linux.

## Use

Add the dependency in your `build.zig.zon` by running the following command:
```bash
zig fetch --save git+https://github.com/allyourcodebase/json-c#0.17
```

Then, in your `build.zig`:
```zig
const jsonc = b.dependency("json-c", { .target = target, .optimize = optimize });
const libjsonc = jsonc.artifact("json-c");
// wherever needed:
exe.linkLibrary(libjsonc);
```
