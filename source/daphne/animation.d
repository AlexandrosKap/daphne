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
    static if (is(T == Num)) {
        T value = 0;
    } else {
        T value;
    }
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

Num duration(T)(Animation!T a) {
    return a.frames.length != 0 ? a.frames[$ - 1] - a.frames[0] : 0;
}

Num progress(T)(Animation!T a) {
    if (a.frames.length == 0) {
        return 0;
    } else if (a.time <= a.frames[0].time) {
        return 0;
    } else if (a.time >= a.frames[$ - 1].time) {
        return 1;
    } else if (a.frames[$ - 1].time != 0) {
        return a.time / a.frames[$ - 1].time;
    } else {
        return 0;
    }
}

Frame!T currentFrame(T)(Animation!T a) {
    if (a.frames.length == 0) {
        return Frame!T();
    } else if (a.time <= a.frames[0].time) {
        return a.frames[0];
    } else if (a.time >= a.frames[$ - 1].time) {
        return a.frames[$ - 1];
    } else {
        foreach (i, frame; a.frames.items) {
            if (a.time <= frame.time) {
                Frame!T from = a.frames[i - 1];
                Frame!T to = a.frames[i];
                Num weight = (a.time - from.time) / (to.time - from.time);
                return Frame!T(
                    ease(from.value, to.value, weight, from.f),
                    a.time,
                    from.f,
                );
            }
        }
        assert(0, "sowwy but somewing went wong uwu");
    }
}

void jumpToStartFrame(T)(ref Animation!T a) {
    a.time = startTime(a);
}

void jumpToEndFrame(T)(ref Animation!T a) {
    a.time = endTime(a);
}

void update(T)(ref Animation!T a, Num amount) {
    a.time += amount;
}

void updateAndLoop(T)(ref Animation!T a, Num amount) {
    a.time += amount;
    Num d = duration(a);
    Num t1 = startTime(a);
    Num t2 = endTime(a);
    while (a.time < t1) {
        time += d;
    }
    while (time > t2) {
        time -= d;
    }
}

unittest {
    Animation!Num animation;
    animation.frames.append(Frame!Num(15, 1));
    animation.frames.append(Frame!Num(30, 2));

    assert(animation.time == 0);
    assert(animation.startTime == 1);
    assert(animation.endTime == 2);

    assert(animation.progress == 0);
    assert(animation.currentFrame.value == 15);
    animation.jumpToStartFrame();
    foreach (i; 0 .. 10) {
        animation.update(0.25);
    }
    assert(animation.progress == 1);
    assert(animation.currentFrame.value == 30);
    disposeAnimation(animation);
}
