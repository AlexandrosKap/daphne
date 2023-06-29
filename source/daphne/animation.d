// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.animation;

import daphne.memory;
public import daphne.math;

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

struct Animation(T) if (isFrameType!T) {
    List!(Frame!T) frames;
    Num time = 0;
}

Animation!T makeAnimation(T)(size_t capacity) {
    Animation!T result;
    result.frames = makeList!(Frame!T)(capacity);
    return result;
}

void disposeAnimation(T)(ref Animation!T a) {
    disposeList(a.frames);
}

Num startTime(T)(Animation!T a) {
    return a.frames.length != 0 ? a.frames[0].time : 0;
}

Num endTime(T)(Animation!T a) {
    return a.frames.length != 0 ? a.frames[$ - 1].time : 0;
}

Num progress(T)(Animation!T a) {
    return (a.frames.length != 0 && a.frames[$ - 1].time != 0) ? time / a.frames[$ - 1].time : 0;
}

Frame!T currentFrame(T)(Animation!T a) {
    if (a.frames.length == 0) {
        return Frame!T();
    } else if (a.time <= a.frames[0].time) {
        return a.frames[0];
    } else if (a.time >= a.frames[$ - 1].time) {
        return a.frames[$ - 1];
    } else {
        assert(0, "sowwy but not done uwu");
    }
}

unittest {
    Animation!Num animation;
    animation.frames.append(Frame!Num(15, 1));
    animation.frames.append(Frame!Num(30, 2));

    assert(animation.time == 0);
    assert(animation.startTime == 1);
    assert(animation.endTime == 2);
    assert(animation.currentFrame == Frame!Num(15, 1));
    disposeAnimation(animation);

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
