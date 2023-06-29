// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.optional;

nothrow @nogc @safe:

struct Optional(T) {
    bool _isSome;
    T _value;
}

Optional!T some(T)(T value = T.init) {
    return Optional!T(true, value);
}

Optional!T none(T)() {
    return Optional!T(false);
}

bool isSome(T)(Optional!T o) {
    return o._isSome;
}

bool isNone(T)(Optional!T o) {
    return !o._isSome;
}

T value(T)(Optional!T o) {
    if (o._isSome) {
        return o._value;
    } else {
        assert(0, "value does not exist");
    }
}

T valueOr(T)(Optional!T o, T value) {
    if (o._isSome) {
        return o._value;
    } else {
        return value;
    }
}

unittest {
    assert(isSome(some!int()) == true);
    assert(isSome(none!int()) == false);
    assert(valueOr(some!int(), 69) == 0);
    assert(valueOr(none!int(), 69) == 69);
}
