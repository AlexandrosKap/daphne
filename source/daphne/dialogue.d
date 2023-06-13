// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.dialogue;

// TODO: Need to add a lot of things.
struct Dialogue(T) {
pure nothrow @nogc @safe:
    T[] lines;
    size_t index;

    this(T[] lines) {
        this.lines = lines;
    }

    size_t length() {
        return lines.length;
    }

    T line() {
        return lines[index];
    }

    bool hasEnded() {
        return index >= length;
    }

    void update() {
        index += 1;
    }
}

// TODO: Need to add something here.
unittest {
    auto lines = ["one", "two", "three"];
    auto dialogue = Dialogue!string(lines);
}
