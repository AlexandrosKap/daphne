// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.dialogue;

enum ActorState {
    neutral,
    happy,
    angry,
    sad,
    nervous,
    serious,
    uncomfortable,
    unimpressed,
    annoyed,
    confused,
    concerned,
    disheartened,
    shocked,
    surprised,
    exhausted,
    worried,
    talking,
    thinking,
    explaining,
    blushing,
    smiling,
    smirking,
    laughing,
}

enum ActorPosition {
    center,
    left,
    right,
    farLeft,
    farRight,
}

// TODO: Think about it more...
struct Line {
pure nothrow @nogc @safe:
    string content;
    string actor;
    ActorState state;
    ActorPosition position;

    this(string content) {
        this.content = content;
    }
}

// TODO: Need to add a lot of things.
struct Dialogue {
pure nothrow @nogc @safe:
    Line[] lines;
    size_t index;

    this(Line[] lines) {
        this.lines = lines;
    }

    size_t length() {
        return lines.length;
    }
}

// TODO: Need to add something here.
unittest {
    Line[2] lines = [Line("Hello..."), Line("World!")];
    Dialogue d = Dialogue(lines);
}
