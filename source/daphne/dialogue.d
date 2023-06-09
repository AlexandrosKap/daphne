// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.dialogue;

// TODO: Think about it more...
struct Line(T) {
pure nothrow @nogc @safe:
    string content;
    T info;

    this(string content) {
        this.content = content;
    }

    this(string content, T info) {
        this.content = content;
        this.info = info;
    }
}

// TODO: Need to add a lot of things.
struct Dialogue(T) {
pure nothrow @nogc @safe:
    Line!T[] lines;
    size_t index;

    this(Line!T[] lines) {
        this.lines = lines;
    }

    size_t length() {
        return lines.length;
    }
}

// TODO: Need to add something here.
unittest {
    Line!int[2] lines = [Line!int("Hello..."), Line!int("World!")];
    auto d = Dialogue!int(lines);
}
