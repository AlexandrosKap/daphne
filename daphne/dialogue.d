// License: MIT | See LICENSE file in repo.

module daphne.dialogue;

struct Info {
pure nothrow @nogc @safe:
    string actor;
    string command;

    this(string actor, string command) {
        this.actor = actor;
        this.command = command;
    }

    this(string actor) {
        this(actor, "");
    }
}

struct Line(T) {
pure nothrow @nogc @safe:
    string content;
    T info;

    this(string content, T info) {
        this.content = content;
        this.info = info;
    }

    this(string content) {
        this(content, T.init);
    }
}

struct Dialogue(T) {
pure nothrow @safe:
    // TODO: Need to add a lot of things.
    Line!T[] lines;
    size_t index;

    this(size_t length) {
        this.lines = new Line!T[length];
    }

    size_t length() {
        return lines.length;
    }
}

unittest {
    // TODO: Need to add something here.
    auto d = Dialogue!Info(4);
}
