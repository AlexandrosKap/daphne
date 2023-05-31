#!/bin/env rdmd

import std.algorithm;
import std.file;
import std.parallelism;
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
    foreach (file; parallel(dirEntries(".", SpanMode.depth))) {
        if (file.name.endsWith(".d")) {
            writeln("formatting: " ~ file.name);
            wait(spawnShell(dfmt ~ file.name));
        }
    }
}
