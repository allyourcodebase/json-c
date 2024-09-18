# `build.zig` for json-c

Provides a package to be used by the zig package manager for C programs.

## Status

For now the hard-coded config assumes linux.

| Refname | json-c version         | Zig `0.12.x` | Zig `0.13.x` | Zig `0.14.0-dev` |
|---------|------------------------|--------------|--------------|------------------|
| `0.17`  | `json-c-0.17-20230812` | ✅           | ✅           | ✅               |
| `0.18`  | `json-c-0.18-20240915` | ✅           | ✅           | ✅               |


## Use

Add the dependency in your `build.zig.zon` by running the following command:
```bash
zig fetch --save git+https://github.com/allyourcodebase/json-c#0.18
```

Then, in your `build.zig`:
```zig
const jsonc = b.dependency("json-c", { .target = target, .optimize = optimize });
const libjsonc = jsonc.artifact("json-c");
// wherever needed:
exe.linkLibrary(libjsonc);
```
