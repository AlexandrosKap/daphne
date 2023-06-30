// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.math;

import math = core.stdc.math;

nothrow @nogc @safe:

alias Num = float;
alias EasingFunc = Num function(Num x);

enum {
    pi = 3.141592,
    pi2 = pi / 2,
    pi4 = pi / 4,
}

enum {
    left = Vec2(-1, 0),
    right = Vec2(1, 0),
    up = Vec2(0, -1),
    down = Vec2(0, 1),
}

enum {
    red = RGBA(255, 0, 0, 255),
    green = RGBA(0, 255, 0, 255),
    blue = RGBA(0, 0, 255, 255),
    yellow = RGBA(255, 255, 0, 255),
    magenta = RGBA(255, 0, 255, 255),
    cyan = RGBA(0, 255, 255, 255),
    black = RGBA(0, 0, 0, 255),
    white = RGBA(255, 255, 255, 255),
    blank = RGBA(),
}

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

struct RGBA {
    ubyte r;
    ubyte g;
    ubyte b;
    ubyte a;
}

struct Line {
    Num x1 = 0;
    Num y1 = 0;
    Num x2 = 0;
    Num y2 = 0;
}

struct Circ {
    Num x = 0;
    Num y = 0;
    Num r = 0;
}

struct Rect {
    Num x = 0;
    Num y = 0;
    Num w = 0;
    Num h = 0;
}

struct Vec2 {
    Num x = 0;
    Num y = 0;

    pragma(inline, true)
    Vec2 opUnary(string op)() nothrow @nogc @safe {
        return Vec2(
            mixin(op ~ "x"),
            mixin(op ~ "y"),
        );
    }

    pragma(inline, true)
    Vec2 opBinary(string op)(Vec2 rhs) nothrow @nogc @safe {
        return Vec2(
            mixin("x " ~ op ~ " rhs.x"),
            mixin("y " ~ op ~ " rhs.y"),
        );
    }

    pragma(inline, true)
    void opOpAssign(string op)(Vec2 rhs) nothrow @nogc @safe {
        mixin("x " ~ op ~ "= rhs.x;");
        mixin("y " ~ op ~ "= rhs.y;");
    }

    pragma(inline, true)
    ref Num opIndex(size_t index) return nothrow @nogc @safe {
        if (index == 0) {
            return x;
        } else if (index == 1) {
            return y;
        } else {
            assert(0, "index out of range");
        }
    }

    pragma(inline, true)
    size_t opDollar(size_t index)() nothrow @nogc @safe {
        return 2;
    }
}

struct Vec3 {
    Num x = 0;
    Num y = 0;
    Num z = 0;

    pragma(inline, true)
    Vec3 opUnary(string op)() nothrow @nogc @safe {
        return Vec3(
            mixin(op ~ "x"),
            mixin(op ~ "y"),
            mixin(op ~ "z"),
        );
    }

    pragma(inline, true)
    Vec3 opBinary(string op)(Vec3 rhs) nothrow @nogc @safe {
        return Vec3(
            mixin("x " ~ op ~ " rhs.x"),
            mixin("y " ~ op ~ " rhs.y"),
            mixin("z " ~ op ~ " rhs.z"),
        );
    }

    pragma(inline, true)
    void opOpAssign(string op)(Vec3 rhs) nothrow @nogc @safe {
        mixin("x " ~ op ~ "= rhs.x;");
        mixin("y " ~ op ~ "= rhs.y;");
        mixin("z " ~ op ~ "= rhs.z;");
    }

    pragma(inline, true)
    ref Num opIndex(size_t index) return nothrow @nogc @safe {
        if (index == 0) {
            return x;
        } else if (index == 1) {
            return y;
        } else if (index == 2) {
            return z;
        } else {
            assert(0, "index out of range");
        }
    }

    pragma(inline, true)
    size_t opDollar(size_t index)() nothrow @nogc @safe {
        return 3;
    }
}

struct Vec4 {
    Num x = 0;
    Num y = 0;
    Num z = 0;
    Num w = 0;

    pragma(inline, true)
    Vec4 opUnary(string op)() nothrow @nogc @safe {
        return Vec4(
            mixin(op ~ "x"),
            mixin(op ~ "y"),
            mixin(op ~ "z"),
            mixin(op ~ "w"),
        );
    }

    pragma(inline, true)
    Vec4 opBinary(string op)(Vec4 rhs) nothrow @nogc @safe {
        return Vec4(
            mixin("x " ~ op ~ " rhs.x"),
            mixin("y " ~ op ~ " rhs.y"),
            mixin("z " ~ op ~ " rhs.z"),
            mixin("w " ~ op ~ " rhs.w"),
        );
    }

    pragma(inline, true)
    void opOpAssign(string op)(Vec4 rhs) nothrow @nogc @safe {
        mixin("x " ~ op ~ "= rhs.x;");
        mixin("y " ~ op ~ "= rhs.y;");
        mixin("z " ~ op ~ "= rhs.z;");
        mixin("w " ~ op ~ "= rhs.w;");
    }

    pragma(inline, true)
    ref Num opIndex(size_t index) return nothrow @nogc @safe {
        if (index == 0) {
            return x;
        } else if (index == 1) {
            return y;
        } else if (index == 2) {
            return z;
        } else if (index == 3) {
            return w;
        } else {
            assert(0, "index out of range");
        }
    }

    pragma(inline, true)
    size_t opDollar(size_t index)() nothrow @nogc @safe {
        return 4;
    }
}

// --- Basic procedures

static if (is(Num == float)) {
    Num cos(Num x) {
        return math.cosf(x);
    }

    Num sin(Num x) {
        return math.sinf(x);
    }

    Num pow(Num x, Num y) {
        return math.powf(x, y);
    }

    Num sqrt(Num x) {
        return math.sqrtf(x);
    }

    Num abs(Num x) {
        return math.fabsf(x);
    }

    Num floor(Num x) {
        return math.floorf(x);
    }

    Num round(Num x) {
        return math.roundf(x);
    }

    Num ceil(Num x) {
        return math.ceilf(x);
    }
} else static if (is(Num == double)) {
    Num cos(Num x) {
        return math.cos(x);
    }

    Num sin(Num x) {
        return math.sin(x);
    }

    Num pow(Num x, Num y) {
        return math.pow(x, y);
    }

    Num sqrt(Num x) {
        return math.sqrt(x);
    }

    Num abs(Num x) {
        return math.fabs(x);
    }

    Num floor(Num x) {
        return math.floor(x);
    }

    Num round(Num x) {
        return math.round(x);
    }

    Num ceil(Num x) {
        return math.ceil(x);
    }
} else static if (is(Num == real)) {
    Num cos(Num x) {
        return math.cosl(x);
    }

    Num sin(Num x) {
        return math.sinl(x);
    }

    Num pow(Num x, Num y) {
        return math.powl(x, y);
    }

    Num sqrt(float x) {
        return math.sqrtl(x);
    }

    Num abs(Num x) {
        return math.fabsl(x);
    }

    Num floor(Num x) {
        return math.floorl(x);
    }

    Num round(Num x) {
        return math.roundl(x);
    }

    Num ceil(Num x) {
        return math.ceill(x);
    }
}

Num min(Num a, Num b) {
    return a <= b ? a : b;
}

Num max(Num a, Num b) {
    return a >= b ? a : b;
}

Num lerp(Num a, Num b, Num weight) {
    return a + (b - a) * weight;
}

Num ease(Num a, Num b, Num weight, EasingFunc f) {
    return a + (b - a) * f(weight);
}

Num easeLinear(Num x) {
    return x;
}

Num easeInSine(Num x) {
    return 1 - cos((x * pi) / 2);
}

Num easeOutSine(Num x) {
    return sin((x * pi) / 2);
}

Num easeInOutSine(Num x) {
    return -(cos(pi * x) - 1) / 2;
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

Num easeInQuart(Num x) {
    return x * x * x * x;
}

Num easeOutQuart(Num x) {
    return 1 - pow(1 - x, 4);
}

Num easeInOutQuart(Num x) {
    if (x < 0.5) {
        return 8 * x * x * x * x;
    } else {
        return 1 - pow(-2 * x + 2, 4) / 2;
    }
}

Num easeInQuint(Num x) {
    return x * x * x * x * x;
}

Num easeOutQuint(Num x) {
    return 1 - pow(1 - x, 5);
}

Num easeInOutQuint(Num x) {
    if (x < 0.5) {
        return 16 * x * x * x * x * x;
    } else {
        return 1 - pow(-2 * x + 2, 5) / 2;
    }
}

// --- RGBA procedures

RGBA rgba(ubyte r, ubyte g, ubyte b, ubyte a) {
    return RGBA(r, g, b, a);
}

RGBA rgba(ubyte r, ubyte g, ubyte b) {
    return RGBA(r, g, b, 255);
}

RGBA rgba(ubyte r) {
    return RGBA(r, r, r, 255);
}

RGBA lerp(RGBA v, RGBA to, Num weight) {
    Num r = cast(Num) v.r + cast(Num)(to.r - v.r) * weight;
    Num g = cast(Num) v.g + cast(Num)(to.g - v.g) * weight;
    Num b = cast(Num) v.b + cast(Num)(to.b - v.b) * weight;
    Num a = cast(Num) v.a + cast(Num)(to.a - v.a) * weight;
    return RGBA(
        r < 0 ? 0 : r > 255 ? 255 : cast(ubyte) r,
        g < 0 ? 0 : g > 255 ? 255 : cast(ubyte) g,
        b < 0 ? 0 : b > 255 ? 255 : cast(ubyte) b,
        a < 0 ? 0 : a > 255 ? 255 : cast(ubyte) a,
    );
}

RGBA ease(RGBA v, RGBA to, Num weight, EasingFunc f) {
    Num r = cast(Num) v.r + cast(Num)(to.r - v.r) * f(weight);
    Num g = cast(Num) v.g + cast(Num)(to.g - v.g) * f(weight);
    Num b = cast(Num) v.b + cast(Num)(to.b - v.b) * f(weight);
    Num a = cast(Num) v.a + cast(Num)(to.a - v.a) * f(weight);
    return RGBA(
        r < 0 ? 0 : r > 255 ? 255 : cast(ubyte) r,
        g < 0 ? 0 : g > 255 ? 255 : cast(ubyte) g,
        b < 0 ? 0 : b > 255 ? 255 : cast(ubyte) b,
        a < 0 ? 0 : a > 255 ? 255 : cast(ubyte) a,
    );
}

// --- Line procedures

Line line(Num x1, Num y1, Num x2, Num y2) {
    return Line(x1, y1, x2, y2);
}

Line line(Vec2 a, Vec2 b) {
    return Line(a.x, a.y, b.x, b.y);
}

Vec2 startPoint(Line l) {
    return Vec2(l.x1, l.y1);
}

void setStartPoint(ref Line l, Vec2 value) {
    l.x1 = value.x;
    l.y1 = value.y;
}

Vec2 endPoint(Line l) {
    return Vec2(l.x2, l.y2);
}

void setEndPoint(ref Line l, Vec2 value) {
    l.x2 = value.x;
    l.y2 = value.y;
}

Line lerp(Line l, Line to, Num weight) {
    return Line(
        l.x1 + (to.x1 - l.x1) * weight,
        l.y1 + (to.y1 - l.y1) * weight,
        l.x2 + (to.x2 - l.x2) * weight,
        l.y2 + (to.y2 - l.y2) * weight,
    );
}

Line ease(Line l, Line to, Num weight, EasingFunc f) {
    return Line(
        l.x1 + (to.x1 - l.x1) * f(weight),
        l.y1 + (to.y1 - l.y1) * f(weight),
        l.x2 + (to.x2 - l.x2) * f(weight),
        l.y2 + (to.y2 - l.y2) * f(weight),
    );
}

// --- Circ procedures

Circ circ(Num x, Num y, Num r) {
    return Circ(x, y, r);
}

Circ circ(Vec2 center, Num r) {
    return Circ(center.x, center.y, r);
}

Vec2 centerPoint(Circ c) {
    return Vec2(c.x, c.y);
}

void setCenterPoint(ref Circ c, Vec2 value) {
    c.x = value.x;
    c.y = value.y;
}

Circ lerp(Circ c, Circ to, Num weight) {
    return Circ(
        c.x + (to.x - c.x) * weight,
        c.y + (to.y - c.y) * weight,
        c.r + (to.r - c.r) * weight,
    );
}

Circ ease(Circ c, Circ to, Num weight, EasingFunc f) {
    return Circ(
        c.x + (to.x - c.x) * f(weight),
        c.y + (to.y - c.y) * f(weight),
        c.r + (to.r - c.r) * f(weight),
    );
}

// --- Rect procedures

Rect rect(Num x, Num y, Num w, Num h) {
    return Rect(x, y, w, h);
}

Rect rect(Vec2 start, Vec2 size) {
    return Rect(start.x, start.y, size.x, size.y);
}

Vec2 size(Rect r) {
    return Vec2(r.w, r.h);
}

void setSize(ref Rect r, Vec2 value) {
    r.w = value.x;
    r.h = value.y;
}

Vec2 startPoint(Rect r) {
    return Vec2(r.x, r.y);
}

void setStartpoint(ref Rect r, Vec2 value) {
    r.x = value.x;
    r.y = value.y;
}

Vec2 centerPoint(Rect r) {
    return Vec2(r.x + r.w / 2, r.y + r.h / 2);
}

void setCenterPoint(ref Rect r, Vec2 value) {
    r.x = value.x - r.w / 2;
    r.y = value.y - r.h / 2;
}

Vec2 endPoint(Rect r) {
    return Vec2(r.x + r.w, r.y + r.h);
}

void setEndPoint(ref Rect r, Vec2 value) {
    r.w = value.x - r.x;
    r.h = value.y - r.y;
}

Num area(Rect r) {
    return r.w * r.h;
}

Vec2 point(Rect r, Anchor from) {
    final switch (from) {
    case Anchor.topLeft:
        return Vec2(r.x, r.y);
    case Anchor.top:
        return Vec2(r.x + r.w / 2, r.y);
    case Anchor.topRight:
        return Vec2(r.x + r.w, r.y);
    case Anchor.centerLeft:
        return Vec2(r.x, r.y + r.h / 2);
    case Anchor.center:
        return Vec2(r.x + r.w / 2, r.y + r.h / 2);
    case Anchor.centerRight:
        return Vec2(r.x + r.w, r.y + r.h / 2);
    case Anchor.bottomLeft:
        return Vec2(r.x, r.y + r.h);
    case Anchor.bottom:
        return Vec2(r.x + r.w / 2, r.y + r.h);
    case Anchor.bottomRight:
        return Vec2(r.x + r.w, r.y + r.h);
    }
}

bool hasPoint(Rect r, Vec2 point) {
    return point.x >= r.x &&
        point.x <= r.x + r.w &&
        point.y >= r.y &&
        point.y <= r.y + r.h;
}

bool isIntersecting(Rect r, Rect other) {
    return r.x + r.w >= other.x &&
        r.x <= other.x + other.w &&
        r.y + r.h >= other.y &&
        r.y <= other.y + other.h;
}

Rect intersection(Rect r, Rect other) {
    if (isIntersecting(r, other)) {
        Num maxx = max(r.x, other.x);
        Num maxy = max(r.y, other.y);
        return Rect(
            maxx,
            maxy,
            min(r.x + r.w, other.x + other.w) - maxx,
            min(r.y + r.h, other.y + other.h) - maxy,
        );
    } else {
        return Rect();
    }
}

Rect merger(Rect r, Rect other) {
    Num minx = min(r.x, other.x);
    Num miny = min(r.y, other.y);
    return Rect(
        minx,
        miny,
        max(r.x + r.w, other.x + other.w) - minx,
        max(r.y + r.h, other.y + other.h) - miny,
    );
}

Rect leftSide(Rect r, Num amount) {
    return Rect(r.x, r.y, amount, r.h);
}

Rect outsideLeftSide(Rect r, Num amount) {
    return Rect(r.x - amount, r.y, amount, r.h);
}

Rect cutLeftSide(ref Rect r, Num amount) {
    auto side = leftSide(r, amount);
    r.x = min(r.w, r.x + amount);
    r.w = max(r.x, r.w - amount);
    return side;
}

Rect rightSide(Rect r, Num amount) {
    return Rect(r.x + r.w - amount, r.y, amount, r.h);
}

Rect outsideRightSide(Rect r, Num amount) {
    return Rect(r.x + r.w, r.y, amount, r.h);
}

Rect cutRightSide(ref Rect r, Num amount) {
    auto side = rightSide(r, amount);
    r.w = max(r.x, r.w - amount);
    return side;
}

Rect topSide(Rect r, Num amount) {
    return Rect(r.x, r.y, r.w, amount);
}

Rect outsideTopSide(Rect r, Num amount) {
    return Rect(r.x, r.y - amount, r.w, amount);
}

Rect cutTopSide(ref Rect r, Num amount) {
    auto side = topSide(r, amount);
    r.y = min(r.h, r.y + amount);
    r.h = max(r.y, r.h - amount);
    return side;
}

Rect bottomSide(Rect r, Num amount) {
    return Rect(r.x, r.y + r.h - amount, r.w, amount);
}

Rect outsideBottomSide(Rect r, Num amount) {
    return Rect(r.x, r.y + r.h, r.w, amount);
}

Rect cutBottomSide(ref Rect r, Num amount) {
    auto side = bottomSide(r, amount);
    r.h = max(r.y, r.h - amount);
    return side;
}

Rect side(Rect r, Side from, Num amount) {
    final switch (from) {
    case Side.left:
        return leftSide(r, amount);
    case Side.right:
        return rightSide(r, amount);
    case Side.top:
        return topSide(r, amount);
    case Side.bottom:
        return bottomSide(r, amount);
    }
}

Rect outsideSide(Rect r, Side from, Num amount) {
    final switch (from) {
    case Side.left:
        return outsideLeftSide(r, amount);
    case Side.right:
        return outsideRightSide(r, amount);
    case Side.top:
        return outsideTopSide(r, amount);
    case Side.bottom:
        return outsideBottomSide(r, amount);
    }
}

Rect cutSide(ref Rect r, Side from, Num amount) {
    final switch (from) {
    case Side.left:
        return cutLeftSide(r, amount);
    case Side.right:
        return cutRightSide(r, amount);
    case Side.top:
        return cutTopSide(r, amount);
    case Side.bottom:
        return cutBottomSide(r, amount);
    }
}

void extendLeftSide(ref Rect r, Num amount) {
    r.x -= amount;
    r.w += amount;
}

void extendRightSide(ref Rect r, Num amount) {
    r.w += amount;
}

void extendTopSide(ref Rect r, Num amount) {
    r.y -= amount;
    r.h += amount;
}

void extendBottomSide(ref Rect r, Num amount) {
    r.h += amount;
}

void extendSide(ref Rect r, Side from, Num amount) {
    final switch (from) {
    case Side.left:
        extendLeftSide(r, amount);
        break;
    case Side.right:
        extendRightSide(r, amount);
        break;
    case Side.top:
        extendTopSide(r, amount);
        break;
    case Side.bottom:
        extendBottomSide(r, amount);
        break;
    }
}

void extendLeftRightSides(ref Rect r, Num amount) {
    extendLeftSide(r, amount);
    extendRightSide(r, amount);
}

void extendTopBottomSides(ref Rect r, Num amount) {
    extendTopSide(r, amount);
    extendBottomSide(r, amount);
}

void extendSides(ref Rect r, Num amount) {
    extendLeftRightSides(r, amount);
    extendTopBottomSides(r, amount);
}

void contractLeftSide(ref Rect r, Num amount) {
    r.x += amount;
    r.w -= amount;
}

void contractRightSide(ref Rect r, Num amount) {
    r.w -= amount;
}

void contractTopSide(ref Rect r, Num amount) {
    r.y += amount;
    r.h -= amount;
}

void contractBottomSide(ref Rect r, Num amount) {
    r.h -= amount;
}

void contractSide(ref Rect r, Side from, Num amount) {
    final switch (from) {
    case Side.left:
        contractLeftSide(r, amount);
        break;
    case Side.right:
        contractRightSide(r, amount);
        break;
    case Side.top:
        contractTopSide(r, amount);
        break;
    case Side.bottom:
        contractBottomSide(r, amount);
        break;
    }
}

void contractLeftRightSides(ref Rect r, Num amount) {
    contractLeftSide(r, amount);
    contractRightSide(r, amount);
}

void contractTopBottomSides(ref Rect r, Num amount) {
    contractTopSide(r, amount);
    contractBottomSide(r, amount);
}

void contractSides(ref Rect r, Num amount) {
    contractLeftRightSides(r, amount);
    contractTopBottomSides(r, amount);
}

Rect lerp(Rect r, Rect to, Num weight) {
    return Rect(
        r.x + (to.x - r.x) * weight,
        r.y + (to.y - r.y) * weight,
        r.w + (to.w - r.w) * weight,
        r.h + (to.h - r.h) * weight,
    );
}

Rect ease(Rect r, Rect to, Num weight, EasingFunc f) {
    return Rect(
        r.x + (to.x - r.x) * f(weight),
        r.y + (to.y - r.y) * f(weight),
        r.w + (to.w - r.w) * f(weight),
        r.h + (to.h - r.h) * f(weight),
    );
}

// --- Vec2 procedures

Vec2 vec2(Num x, Num y) {
    return Vec2(x, y);
}

Vec2 vec2(Num x) {
    return Vec2(x, x);
}

Num magnitudeSquared(Vec2 v) {
    return v.x * v.x + v.y * v.y;
}

Num magnitude(Vec2 v) {
    return sqrt(v.x * v.x + v.y * v.y);
}

Vec2 normalized(Vec2 v) {
    Num m = magnitude(v);
    if (m != 0) {
        return Vec2(v.x / m, v.y / m);
    } else {
        return Vec2();
    }
}

Vec2 sqrt(Vec2 v) {
    return Vec2(sqrt(v.x), sqrt(v.y));
}

Vec2 abs(Vec2 v) {
    return Vec2(abs(v.x), abs(v.y));
}

Vec2 floor(Vec2 v) {
    return Vec2(floor(v.x), floor(v.y));
}

Vec2 round(Vec2 v) {
    return Vec2(round(v.x), round(v.y));
}

Vec2 ceil(Vec2 v) {
    return Vec2(ceil(v.x), ceil(v.y));
}

Vec2 distanceTo(Vec2 v, Vec2 to) {
    return abs(to - v);
}

Vec2 directionTo(Vec2 v, Vec2 to) {
    return normalized(to - v);
}

Vec2 directionToSquared(Vec2 v, Vec2 to) {
    return (to - v);
}

Vec2 point(Vec2 v, Anchor from) {
    final switch (from) {
    case Anchor.topLeft:
        return Vec2(0, 0);
    case Anchor.top:
        return Vec2(v.x / 2, 0);
    case Anchor.topRight:
        return Vec2(v.x, 0);
    case Anchor.centerLeft:
        return Vec2(0, v.y / 2);
    case Anchor.center:
        return Vec2(v.x / 2, v.y / 2);
    case Anchor.centerRight:
        return Vec2(v.x, v.y / 2);
    case Anchor.bottomLeft:
        return Vec2(0, v.y);
    case Anchor.bottom:
        return Vec2(v.x / 2, v.y);
    case Anchor.bottomRight:
        return Vec2(v.x, v.y);
    }
}

Vec2 lerp(Vec2 v, Vec2 to, Num weight) {
    return Vec2(
        v.x + (to.x - v.x) * weight,
        v.y + (to.y - v.y) * weight,
    );
}

Vec2 ease(Vec2 v, Vec2 to, Num weight, EasingFunc f) {
    return Vec2(
        v.x + (to.x - v.x) * f(weight),
        v.y + (to.y - v.y) * f(weight),
    );
}

// --- Vec3 procedures

Vec3 vec3(Num x, Num y, Num z) {
    return Vec3(x, y, z);
}

Vec3 vec3(Num x) {
    return Vec3(x, x, x);
}

Num magnitudeSquared(Vec3 v) {
    return v.x * v.x + v.y * v.y + v.z * v.z;
}

Num magnitude(Vec3 v) {
    return sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
}

Vec3 normalized(Vec3 v) {
    Num m = magnitude(v);
    if (m != 0) {
        return Vec3(v.x / m, v.y / m, v.z / m);
    } else {
        return Vec3();
    }
}

Vec3 sqrt(Vec3 v) {
    return Vec3(sqrt(v.x), sqrt(v.y), sqrt(v.z));
}

Vec3 abs(Vec3 v) {
    return Vec3(abs(v.x), abs(v.y), abs(v.z));
}

Vec3 floor(Vec3 v) {
    return Vec3(floor(v.x), floor(v.y), floor(v.z));
}

Vec3 round(Vec3 v) {
    return Vec3(round(v.x), round(v.y), round(v.z));
}

Vec3 ceil(Vec3 v) {
    return Vec3(ceil(v.x), ceil(v.y), ceil(v.z));
}

Vec3 distanceTo(Vec3 v, Vec3 to) {
    return abs(to - v);
}

Vec3 directionTo(Vec3 v, Vec3 to) {
    return normalized(to - v);
}

Vec3 directionToSquared(Vec3 v, Vec3 to) {
    return (to - v);
}

Vec3 lerp(Vec3 v, Vec3 to, Num weight) {
    return Vec3(
        v.x + (to.x - v.x) * weight,
        v.y + (to.y - v.y) * weight,
        v.z + (to.z - v.z) * weight,
    );
}

Vec3 ease(Vec3 v, Vec3 to, Num weight, EasingFunc f) {
    return Vec3(
        v.x + (to.x - v.x) * f(weight),
        v.y + (to.y - v.y) * f(weight),
        v.z + (to.z - v.z) * f(weight),
    );
}

// --- Vec4 procedures

Vec4 vec4(Num x, Num y, Num z, Num w) {
    return Vec4(x, y, z, w);
}

Vec4 vec4(Num x) {
    return Vec4(x, x, x, x);
}

Num magnitudeSquared(Vec4 v) {
    return v.x * v.x + v.y * v.y + v.z * v.z + v.w * v.w;
}

Num magnitude(Vec4 v) {
    return sqrt(v.x * v.x + v.y * v.y + v.z * v.z + v.w * v.w);
}

Vec4 normalized(Vec4 v) {
    Num m = magnitude(v);
    if (m != 0) {
        return Vec4(v.x / m, v.y / m, v.z / m, v.w / m);
    } else {
        return Vec4();
    }
}

Vec4 sqrt(Vec4 v) {
    return Vec4(sqrt(v.x), sqrt(v.y), sqrt(v.z), sqrt(v.w));
}

Vec4 abs(Vec4 v) {
    return Vec4(abs(v.x), abs(v.y), abs(v.z), abs(v.w));
}

Vec4 floor(Vec4 v) {
    return Vec4(floor(v.x), floor(v.y), floor(v.z), floor(v.w));
}

Vec4 round(Vec4 v) {
    return Vec4(round(v.x), round(v.y), round(v.z), round(v.w));
}

Vec4 ceil(Vec4 v) {
    return Vec4(ceil(v.x), ceil(v.y), ceil(v.z), ceil(v.w));
}

Vec4 distanceTo(Vec4 v, Vec4 to) {
    return abs(to - v);
}

Vec4 directionTo(Vec4 v, Vec4 to) {
    return normalized(to - v);
}

Vec4 directionToSquared(Vec4 v, Vec4 to) {
    return (to - v);
}

Vec4 lerp(Vec4 v, Vec4 to, Num weight) {
    return Vec4(
        v.x + (to.x - v.x) * weight,
        v.y + (to.y - v.y) * weight,
        v.z + (to.z - v.z) * weight,
        v.w + (to.w - v.w) * weight,
    );
}

Vec4 ease(Vec4 v, Vec4 to, Num weight, EasingFunc f) {
    return Vec4(
        v.x + (to.x - v.x) * f(weight),
        v.y + (to.y - v.y) * f(weight),
        v.z + (to.z - v.z) * f(weight),
        v.w + (to.w - v.w) * f(weight),
    );
}

unittest {
    auto r0 = rect(0, 0, 8, 4);
    auto r1 = r0;
    auto r2 = r1.cutSide(Side.right, 4);

    assert(r1.merger(r2) == r0);
    assert(r1.point(Anchor.centerRight) == vec2(r1.x + r1.w, r1.y + r1.h / 2));
}
