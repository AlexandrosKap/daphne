#!/bin/env rdmd

import std.file;
import std.process;
import std.stdio;

enum dfmt = "dfmt" ~
    " -i" ~
    " --brace_style=otbs" ~
    " --single_indent=true" ~
    " --keep_line_breaks=true" ~
    " --split_operator_at_line_end=true" ~
    " ";

void main() {
    foreach (file; dirEntries(".", SpanMode.depth)) {
        auto name = file.name;
        if (name.length >= 3 && name[$ - 2 .. $] == ".d") {
            writeln("formatting: " ~ file.name);
            wait(spawnShell(dfmt ~ file.name));
        }
    }
}
