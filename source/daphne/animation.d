// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.animation;

import std.math;

alias Num = float;
alias EasingFunc = Num function(Num x) pure nothrow @nogc @safe;

pure nothrow @nogc @safe {
    // TODO: Add more easing functions.
    // TODO: Think about curves.

    Num ease(Num a, Num b, Num weight, EasingFunc f) {
        return a + (b - a) * f(weight);
    }

    Num lerp(Num a, Num b, Num weight) {
        return a + (b - a) * weight;
    }

    Num easeLinear(Num x) {
        return x;
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

    Num easeInQuad(Num x) {
        return x * x;
    }

    Num easeOutQuad(Num x) {
        return 1 - (1 - x) * (1 - x);
    }

    Num easeInOutQuad(Num x) {
        if (x < 0.5) {
            return 2 * x * x;
        } else {
            return 1 - pow(-2 * x + 2, 2) / 2;
        }
    }

    Num easeInCubic(Num x) {
        return x * x * x;
    }

    Num easeOutCubic(Num x) {
        return 1 - pow(1 - x, 3);
    }

    Num easeInOutCubic(Num x) {
        if (x < 0.5) {
            return 4 * x * x * x;
        } else {
            return 1 - pow(-2 * x + 2, 3) / 2;
        }
    }
}

struct Frame {
pure nothrow @nogc @safe:
    Num value = 0;
    Num time = 0;
    EasingFunc f = &easeLinear;

    this(Num value, Num time, EasingFunc f) {
        this.value = value;
        this.time = time;
        this.f = f;
    }

    this(Num value, Num time) {
        this(value, time, &easeLinear);
    }
}

// NOTE: Maybe add index to optimize updating.
struct Animation {
pure nothrow @nogc @safe:
    Frame[] frames;
    Num time = 0;

    this(Frame[] frames) {
        this.frames = frames;
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
                    Frame a = frames[i - 1];
                    Frame b = frames[i];
                    Num weight = (time - a.time) / (b.time - a.time);
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
        if (time < start) {
            time += end;
        } else if (time > end) {
            time -= end;
        }
    }

    void makeEnd(size_t index) {
        Frame f = frames[index];
        foreach (i; index + 1 .. length) {
            frames[i] = f;
        }
    }
}

unittest {
    Frame[2] frames = [Frame(15, 1), Frame(30, 2)];
    Animation anim = Animation(frames);

    assert(anim.time == 0);
    assert(anim.start == 1);
    assert(anim.end == 2);
    assert(anim.value == 15);

    anim.jumpToStart();
    foreach (i; 0 .. 5) {
        anim.update(0.25);
    }
    assert(anim.hasEnded);
    assert(anim.value == 30);
}
