// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.animation;

import daphne.math;
import daphne.memory;

nothrow @nogc @safe:

enum isFrameType(T)() {
    return is(T == Num) ||
        is(T == RGBA) ||
        is(T == Line) ||
        is(T == Circ) ||
        is(T == Rect) ||
        is(T == Vec2) ||
        is(T == Vec3) ||
        is(T == Vec4);
}

struct Frame(T) if (isFrameType!T) {
    T value;
    Num time = 0;
    EasingFunc f = &easeLinear;
}

struct FrameSequence(T) if (isFrameType!T) {
    List!(Frame!T) frames;
    Num time = 0;
}

FrameSequence!T makeFrameSequence(T)(size_t capacity) {
    FrameSequence!T result;
    result.frames = makeList!(Frame!T)(capacity);
    return result;
}

void disposeFrameSequence(T)(ref FrameSequence!T s) {
    disposeList(s.frames);
}

bool hasFrames(T)(FrameSequence!T s) {
    return s.frames.length != 0;
}

Num startTime(T)(FrameSequence!T s) {
    return s.frames.length != 0 ? s.frames.items[0].time : 0;
}

Num endTime(T)(FrameSequence!T s) {
    return s.frames.length != 0 ? s.frames.items[$ - 1].time : 0;
}

Num progress(T)(FrameSequence!T s) {
    return s.frames.length != 0 && s.frames.items[$ - 1].time != 0 ? time / s.frames.items[$ - 1]
        : 0;
}

Frame!T currentFrame(T)(FrameSequence!T s) {
    if (s.frames.length == 0) {
        return Frame!T();
    } else if (s.time <= s.frames.items[0].time) {
        return s.frames.items[0];
    } else if (s.time >= s.frames.items[$ - 1].time) {
        return s.frames.items[$ - 1];
    } else {
        assert(0, "Not done with frame(T)(s)");
    }
}

unittest {
    auto animation = FrameSequence!Num();
    scope (exit)
        disposeFrameSequence(animation);
    animation.frames.append(Frame!Num(15, 1));
    animation.frames.append(Frame!Num(30, 2));

    assert(animation.time == 0);
    assert(animation.startTime == 1);
    assert(animation.endTime == 2);
    assert(animation.currentFrame == Frame!Num(15, 1));

    // TODO: Need to add stuff here.
    /*
    anim.jumpToStart();
    foreach (i; 0 .. 5) {
        anim.update(0.25);
    }
    assert(anim.hasEnded);
    assert(anim.value == 30);
    */
}
