// License: MIT | See LICENSE file in repo.

module daphne.animation;

import std.math;
import daphne.config;

pure nothrow @nogc @safe {
    // TODO: Add more easing functions.
    // TODO: Think about curves.

    Num ease(Num a, Num b, Num weight, EasingFunc f) {
        return a + (b - a) * f(weight);
    }

    Num lerp(Num a, Num b, Num weight) {
        return ease(a, b, weight, &linear);
    }

    Num easeInSine(Num x) {
        return 1 - cos((x * PI) / 2);
    }

    Num easeOutSine(Num x) {
        return sin((x * PI) / 2);
    }

    Num easeInOutSine(Num x) {
        return -(cos(PI * x) - 1) / 2;
    }
}

struct Frame {
pure nothrow @nogc @safe:
    Num value = 0;
    Num time = 0;
    EasingFunc f = &linear;

    this(Num value, Num time, EasingFunc f) {
        this.value = value;
        this.time = time;
        this.f = f;
    }

    this(Num value, Num time) {
        this(value, time, &linear);
    }
}

struct Animation {
pure nothrow @safe:
    Frame[] frames;
    Num time = 0;

    this(size_t length) {
        this.frames = new Frame[length];
    }

    size_t length() {
        return frames.length;
    }

    bool isEmpty() {
        return start == end;
    }

    Num start() {
        return length > 0 ? frames[0].time : 0;
    }

    Num end() {
        return length > 0 ? frames[$ - 1].time : 0;
    }

    Num progress() {
        return length > 0 ? time / end : 0;
    }

    Num value() {
        if (length == 0) {
            return 0;
        } else if (time <= frames[0].time) {
            return frames[0].value;
        } else if (time >= frames[$ - 1].time) {
            return frames[$ - 1].value;
        } else {
            foreach (i; 0 .. length) {
                if (frames[i].time > time) {
                    auto a = frames[i - 1];
                    auto b = frames[i];
                    auto weight = (time - a.time) / (b.time - a.time);
                    return ease(a.value, b.value, weight, a.f);
                }
            }
            return 0;
        }
    }

    bool hasStarted() {
        return time > start;
    }

    bool hasEnded() {
        return time >= end;
    }

    void jumpToStart() {
        time = start;
    }

    void jumpToEnd() {
        time = end;
    }

    void update(Num amount) {
        time += amount;
    }

    void updateAndLoop(Num amount) {
        time += amount;
        while (time < start) {
            time += end;
        }
        while (time > end) {
            time -= end;
        }
    }
}

unittest {
    auto anim = Animation(2);
    anim.frames[0] = Frame(15, 1, &easeInOutSine);
    anim.frames[1] = Frame(30, 2);

    assert(anim.time == 0);
    assert(anim.start == 1);
    assert(anim.value == 15);

    anim.jumpToStart();
    foreach (i; 0 .. 5) {
        anim.update(0.25);
    }
    assert(anim.hasEnded);
    assert(anim.value == 30);
}
