// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.math;

import std.algorithm;
import math = std.math;

alias Num = float;
alias EasingFunc = Num function(Num x) pure nothrow @nogc @safe;

enum Anchor {
    topLeft,
    top,
    topRight,
    centerLeft,
    center,
    centerRight,
    bottomLeft,
    bottom,
    bottomRight,
}

enum Side {
    left = Anchor.centerLeft,
    right = Anchor.centerRight,
    top = Anchor.top,
    bottom = Anchor.bottom,
}

enum BasicPalette {
    red = RGBA(255, 0, 0),
    green = RGBA(0, 255, 0),
    blue = RGBA(0, 0, 255),
    yellow = RGBA(255, 255, 0),
    magenta = RGBA(255, 0, 255),
    cyan = RGBA(0, 255, 255),
    black = RGBA(0, 0, 0),
    white = RGBA(255, 255, 255),
}

enum DebugPalette {
    red = RGBA(255, 0, 0, 120),
    green = RGBA(0, 255, 0, 120),
    blue = RGBA(0, 0, 255, 120),
    yellow = RGBA(255, 255, 0, 120),
    magenta = RGBA(255, 0, 255, 120),
    cyan = RGBA(0, 255, 255, 120),
    black = RGBA(0, 0, 0, 120),
    white = RGBA(255, 255, 255, 120),
}

enum CutePalette {
    black = RGBA(0x2b, 0x2b, 0x26),
    darkGray = RGBA(0x70, 0x6b, 0x66),
    lightGray = RGBA(0xa8, 0x9f, 0x94),
    white = RGBA(0xe0, 0xdb, 0xcd),
}

struct Vec2 {
pure nothrow @nogc @safe:
    Num x = 0;
    Num y = 0;

    this(Num x, Num y) {
        this.x = x;
        this.y = y;
    }

    this(Num x) {
        this(x, x);
    }

    this(Anchor from) {
        final switch (from) {
        case Anchor.topLeft:
            this.x = -1;
            this.y = -1;
            break;
        case Anchor.top:
            this.x = 0;
            this.y = -1;
            break;
        case Anchor.topRight:
            this.x = 1;
            this.y = -1;
            break;
        case Anchor.centerLeft:
            this.x = -1;
            this.y = 0;
            break;
        case Anchor.center:
            this.x = 0;
            this.y = 0;
            break;
        case Anchor.centerRight:
            this.x = 1;
            this.y = 0;
            break;
        case Anchor.bottomLeft:
            this.x = -1;
            this.y = 1;
            break;
        case Anchor.bottom:
            this.x = 0;
            this.y = 1;
            break;
        case Anchor.bottomRight:
            this.x = 1;
            this.y = 1;
            break;
        }
    }

    Vec2 opUnary(string op)() {
        return Vec2(
            mixin(op ~ "x"),
            mixin(op ~ "y"),
        );
    }

    Vec2 opBinary(string op)(Vec2 rhs) {
        return Vec2(
            mixin("x " ~ op ~ " rhs.x"),
            mixin("y " ~ op ~ " rhs.y"),
        );
    }

    void opOpAssign(string op)(Vec2 rhs) {
        mixin("x " ~ op ~ "= rhs.x;");
        mixin("y " ~ op ~ "= rhs.y;");
    }

    bool isZero() {
        return x == 0 && y == 0;
    }

    Num magnitudeSquared() {
        return x * x + y * y;
    }

    Num magnitude() {
        return math.sqrt(magnitudeSquared);
    }

    Vec2 normalized() {
        auto m = magnitude;
        if (m != 0) {
            return Vec2(x / m, y / m);
        } else {
            return Vec2();
        }
    }

    Vec2 sqrt() {
        return Vec2(math.sqrt(x), math.sqrt(y));
    }

    Vec2 abs() {
        return Vec2(math.abs(x), math.abs(y));
    }

    Vec2 floor() {
        return Vec2(math.floor(x), math.floor(y));
    }

    Vec2 round() {
        return Vec2(math.round(x), math.round(y));
    }

    Vec2 ceil() {
        return Vec2(math.ceil(x), math.ceil(y));
    }

    Vec2 distanceTo(Vec2 to) {
        return (to - this).abs;
    }

    Vec2 directionToSquared(Vec2 to) {
        return (to - this);
    }

    Vec2 directionTo(Vec2 to) {
        return directionToSquared(to).normalized;
    }

    Vec2 ease(Vec2 to, Num weight, EasingFunc f) {
        return Vec2(
            x + (to.x - x) * f(weight),
            y + (to.y - y) * f(weight),
        );
    }

    Vec2 lerp(Vec2 to, Num weight) {
        return Vec2(
            x + (to.x - x) * weight,
            y + (to.y - y) * weight,
        );
    }
}

struct Vec3 {
pure nothrow @nogc @safe:
    Num x = 0;
    Num y = 0;
    Num z = 0;

    this(Num x, Num y, Num z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    this(Num x) {
        this(x, x, x);
    }

    Vec3 opUnary(string op)() {
        return Vec3(
            mixin(op ~ "x"),
            mixin(op ~ "y"),
            mixin(op ~ "z"),
        );
    }

    Vec3 opBinary(string op)(Vec3 rhs) {
        return Vec3(
            mixin("x " ~ op ~ " rhs.x"),
            mixin("y " ~ op ~ " rhs.y"),
            mixin("z " ~ op ~ " rhs.z"),
        );
    }

    void opOpAssign(string op)(Vec3 rhs) {
        mixin("x " ~ op ~ "= rhs.x;");
        mixin("y " ~ op ~ "= rhs.y;");
        mixin("z " ~ op ~ "= rhs.z;");
    }

    bool isZero() {
        return x == 0 && y == 0 && z == 0;
    }

    Num magnitudeSquared() {
        return x * x + y * y + z * z;
    }

    Num magnitude() {
        return math.sqrt(magnitudeSquared);
    }

    Vec3 normalized() {
        auto m = magnitude;
        if (m != 0) {
            return Vec3(x / m, y / m, z / m);
        } else {
            return Vec3();
        }
    }

    Vec3 sqrt() {
        return Vec3(math.sqrt(x), math.sqrt(y), math.sqrt(z));
    }

    Vec3 abs() {
        return Vec3(math.abs(x), math.abs(y), math.abs(z));
    }

    Vec3 floor() {
        return Vec3(math.floor(x), math.floor(y), math.floor(z));
    }

    Vec3 round() {
        return Vec3(math.round(x), math.round(y), math.round(z));
    }

    Vec3 ceil() {
        return Vec3(math.ceil(x), math.ceil(y), math.ceil(z));
    }

    Vec3 distanceTo(Vec3 to) {
        return (to - this).abs;
    }

    Vec3 directionToSquared(Vec3 to) {
        return (to - this);
    }

    Vec3 directionTo(Vec3 to) {
        return directionToSquared(to).normalized;
    }

    Vec3 ease(Vec3 to, Num weight, EasingFunc f) {
        return Vec3(
            x + (to.x - x) * f(weight),
            y + (to.y - y) * f(weight),
            z + (to.z - z) * f(weight),
        );
    }

    Vec3 lerp(Vec3 to, Num weight) {
        return Vec3(
            x + (to.x - x) * weight,
            y + (to.y - y) * weight,
            z + (to.z - z) * weight,
        );
    }
}

struct Vec4 {
pure nothrow @nogc @safe:
    Num x = 0;
    Num y = 0;
    Num z = 0;
    Num w = 0;

    this(Num x, Num y, Num z, Num w) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }

    this(Num x) {
        this(x, x, x, x);
    }

    Vec4 opUnary(string op)() {
        return Vec4(
            mixin(op ~ "x"),
            mixin(op ~ "y"),
            mixin(op ~ "z"),
            mixin(op ~ "w"),
        );
    }

    Vec4 opBinary(string op)(Vec4 rhs) {
        return Vec4(
            mixin("x " ~ op ~ " rhs.x"),
            mixin("y " ~ op ~ " rhs.y"),
            mixin("z " ~ op ~ " rhs.z"),
            mixin("w " ~ op ~ " rhs.w"),
        );
    }

    void opOpAssign(string op)(Vec4 rhs) {
        mixin("x " ~ op ~ "= rhs.x;");
        mixin("y " ~ op ~ "= rhs.y;");
        mixin("z " ~ op ~ "= rhs.z;");
        mixin("w " ~ op ~ "= rhs.w;");
    }

    bool isZero() {
        return x == 0 && y == 0 && z == 0 && w == 0;
    }

    Num magnitudeSquared() {
        return x * x + y * y + z * z + w * w;
    }

    Num magnitude() {
        return math.sqrt(magnitudeSquared);
    }

    Vec4 normalized() {
        auto m = magnitude;
        if (m != 0) {
            return Vec4(x / m, y / m, z / m, w / m);
        } else {
            return Vec4();
        }
    }

    Vec4 sqrt() {
        return Vec4(math.sqrt(x), math.sqrt(y), math.sqrt(z), math.sqrt(w));
    }

    Vec4 abs() {
        return Vec4(math.abs(x), math.abs(y), math.abs(z), math.abs(w));
    }

    Vec4 floor() {
        return Vec4(math.floor(x), math.floor(y), math.floor(z), math.floor(w));
    }

    Vec4 round() {
        return Vec4(math.round(x), math.round(y), math.round(z), math.round(w));
    }

    Vec4 ceil() {
        return Vec4(math.ceil(x), math.ceil(y), math.ceil(z), math.ceil(w));
    }

    Vec4 distanceTo(Vec4 to) {
        return (to - this).abs;
    }

    Vec4 directionToSquared(Vec4 to) {
        return (to - this);
    }

    Vec4 directionTo(Vec4 to) {
        return directionToSquared(to).normalized;
    }

    Vec4 ease(Vec4 to, Num weight, EasingFunc f) {
        return Vec4(
            x + (to.x - x) * f(weight),
            y + (to.y - y) * f(weight),
            z + (to.z - z) * f(weight),
            w + (to.w - w) * f(weight),
        );
    }

    Vec4 lerp(Vec4 to, Num weight) {
        return Vec4(
            x + (to.x - x) * weight,
            y + (to.y - y) * weight,
            z + (to.z - z) * weight,
            w + (to.w - w) * weight,
        );
    }
}

struct Line {
pure nothrow @nogc @safe:
    Num x1 = 0;
    Num y1 = 0;
    Num x2 = 0;
    Num y2 = 0;

    this(Num x1, Num y1, Num x2, Num y2) {
        this.x1 = x1;
        this.y1 = y1;
        this.x2 = x2;
        this.y2 = y2;
    }

    this(Vec2 a, Vec2 b) {
        this(a.x, a.y, b.x, b.y);
    }

    bool isZero() {
        return x1 == 0 && y1 == 0 && x2 == 0 && y2 == 0;
    }

    Vec2 a() {
        return Vec2(x1, y1);
    }

    void a(Vec2 value) {
        x1 = value.x;
        y1 = value.y;
    }

    Vec2 b() {
        return Vec2(x2, y2);
    }

    void b(Vec2 value) {
        x2 = value.x;
        y2 = value.y;
    }
}

struct Rect {
pure nothrow @nogc @safe:
    Num x = 0;
    Num y = 0;
    Num w = 0;
    Num h = 0;

    this(Num x, Num y, Num w, Num h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    this(Vec2 start, Vec2 size) {
        this(start.x, start.y, size.x, size.y);
    }

    bool isZero() {
        return x == 0 && y == 0 && w == 0 && h == 0;
    }

    Vec2 size() {
        return Vec2(w, h);
    }

    void size(Vec2 value) {
        w = value.x;
        h = value.y;
    }

    Vec2 start() {
        return Vec2(x, y);
    }

    void start(Vec2 value) {
        x = value.x;
        y = value.y;
    }

    Vec2 center() {
        return Vec2(x + w / 2, y + h / 2);
    }

    void center(Vec2 value) {
        x = value.x - w / 2;
        y = value.y - h / 2;
    }

    Vec2 end() {
        return Vec2(x + w, y + h);
    }

    void end(Vec2 value) {
        w = value.x - x;
        h = value.y - y;
    }

    Num area() {
        return w * h;
    }

    bool hasArea() {
        return area != 0;
    }

    Vec2 point(Anchor from) {
        auto s = start;
        final switch (from) {
        case Anchor.topLeft:
            return Vec2(s.x, s.y);
        case Anchor.top:
            return Vec2(s.x + w / 2, s.y);
        case Anchor.topRight:
            return Vec2(s.x + w, s.y);
        case Anchor.centerLeft:
            return Vec2(s.x, s.y + h / 2);
        case Anchor.center:
            return Vec2(s.x + w / 2, s.y + h / 2);
        case Anchor.centerRight:
            return Vec2(s.x + w, s.y + h / 2);
        case Anchor.bottomLeft:
            return Vec2(s.x, s.y + h);
        case Anchor.bottom:
            return Vec2(s.x + w / 2, s.y + h);
        case Anchor.bottomRight:
            return Vec2(s.x + w, s.y + h);
        }
    }

    bool hasPoint(Vec2 point) {
        auto e = end;
        return point.x >= x &&
            point.x <= e.x &&
            point.y >= y &&
            point.y <= e.y;
    }

    bool isIntersecting(Rect other) {
        return x + w >= other.x &&
            x <= other.x + other.w &&
            y + h >= other.y &&
            y <= other.y + other.h;
    }

    Rect intersection(Rect other) {
        if (isIntersecting(other)) {
            auto e1 = end;
            auto e2 = other.end;
            auto maxp = Vec2(max(x, other.x), max(y, other.y));
            return Rect(
                maxp.x,
                maxp.y,
                min(e1.x, e2.x) - maxp.x,
                min(e1.y, e2.y) - maxp.y,
            );
        } else {
            return Rect();
        }
    }

    Rect merger(Rect other) {
        auto e1 = end;
        auto e2 = other.end;
        auto minp = Vec2(min(x, other.x), min(y, other.y));
        return Rect(
            minp.x,
            minp.y,
            max(e1.x, e2.x) - minp.x,
            max(e1.y, e2.y) - minp.y,
        );
    }

    Rect left(Num amount) {
        return Rect(x, y, amount, h);
    }

    Rect outsideLeft(Num amount) {
        return Rect(x - amount, y, amount, h);
    }

    Rect cutLeft(Num amount) {
        auto l = left(amount);
        x = min(w, x + amount);
        w = max(x, w - amount);
        return l;
    }

    Rect right(Num amount) {
        return Rect(x + w - amount, y, amount, h);
    }

    Rect outsideRight(Num amount) {
        return Rect(x + w, y, amount, h);
    }

    Rect cutRight(Num amount) {
        auto r = right(amount);
        w = max(x, w - amount);
        return r;
    }

    Rect top(Num amount) {
        return Rect(x, y, w, amount);
    }

    Rect outsideTop(Num amount) {
        return Rect(x, y - amount, w, amount);
    }

    Rect cutTop(Num amount) {
        auto t = top(amount);
        y = min(h, y + amount);
        h = max(y, h - amount);
        return t;
    }

    Rect bottom(Num amount) {
        return Rect(x, y + h - amount, w, amount);
    }

    Rect outsideBottom(Num amount) {
        return Rect(x, y + h, w, amount);
    }

    Rect cutBottom(Num amount) {
        auto b = bottom(amount);
        h = max(y, h - amount);
        return b;
    }

    Rect side(Side from, Num amount) {
        final switch (from) {
        case Side.left:
            return left(amount);
        case Side.right:
            return right(amount);
        case Side.top:
            return top(amount);
        case Side.bottom:
            return bottom(amount);
        }
    }

    Rect outsideSide(Side from, Num amount) {
        final switch (from) {
        case Side.left:
            return outsideLeft(amount);
        case Side.right:
            return outsideRight(amount);
        case Side.top:
            return outsideTop(amount);
        case Side.bottom:
            return outsideBottom(amount);
        }
    }

    Rect cutSide(Side from, Num amount) {
        final switch (from) {
        case Side.left:
            return cutLeft(amount);
        case Side.right:
            return cutRight(amount);
        case Side.top:
            return cutTop(amount);
        case Side.bottom:
            return cutBottom(amount);
        }
    }

    void extend(Num amount) {
        x -= amount;
        y -= amount;
        w += amount;
        h += amount;
    }

    void contract(Num amount) {
        extend(-amount);
    }
}

struct Circ {
pure nothrow @nogc @safe:
    Num x = 0;
    Num y = 0;
    Num r = 0;

    this(Num x, Num y, Num r) {
        this.x = x;
        this.y = y;
        this.r = r;
    }

    this(Vec2 center, Num r) {
        this(center.x, center.y, r);
    }

    bool isZero() {
        return x == 0 && y == 0 && r == 0;
    }

    Vec2 center() {
        return Vec2(x, y);
    }

    void center(Vec2 value) {
        x = value.x;
        y = value.y;
    }
}

struct RGBA {
    ubyte r;
    ubyte g;
    ubyte b;
    ubyte a;

    this(ubyte r, ubyte g, ubyte b, ubyte a) {
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
    }

    this(ubyte r, ubyte g, ubyte b) {
        this(r, g, b, 255);
    }

    this(ubyte r) {
        this(r, r, r, 255);
    }

    bool isZero() {
        return r == 0 && g == 0 && b == 0 && a == 0;
    }
}

unittest {
    auto r0 = Rect(0, 0, 8, 4);
    auto r1 = r0;
    auto r2 = r1.cutSide(Side.right, 4);

    assert(r1.merger(r2) == r0);
    assert(r1.point(Anchor.centerRight) == Vec2(r1.x + r1.w, r1.y + r1.h / 2));
}
