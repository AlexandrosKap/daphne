// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.memory;

import lib = core.stdc.stdlib;

nothrow @nogc @trusted:

enum {
    defaultListCapacity = 32,
}

struct List(T) {
    T[] items;
    size_t capacity;

    pragma(inline, true)
    ref T opIndex(size_t index) nothrow @nogc @safe {
        return items[index];
    }

    pragma(inline, true)
    T[] opIndex() nothrow @nogc @safe {
        return items[];
    }

    pragma(inline, true)
    T[] opSlice(size_t index)(size_t a, size_t b) nothrow @nogc @safe {
        return items[a .. b];
    }

    pragma(inline, true)
    size_t opDollar(size_t index)() nothrow @nogc @safe {
        return items.length;
    }
}

// --- Allocation

T* alloc(T = void)(size_t size) {
    return cast(T*) lib.malloc(size);
}

T* allocValue(T)(T value = T.init) {
    T* ptr = alloc!T(T.sizeof);
    if (ptr != null) {
        *ptr = value;
        return ptr;
    } else {
        return null;
    }
}

T[] allocArray(T)(size_t length) {
    T* ptr = alloc!T(T.sizeof * length);
    if (ptr != null) {
        return ptr[0 .. length];
    } else {
        return null;
    }
}

bool realloc(T)(ref T* ptr, size_t size) {
    T* newptr = cast(T*) lib.realloc(ptr, size);
    if (newptr != null) {
        ptr = newptr;
        return true;
    } else {
        return false;
    }
}

bool reallocArray(T)(ref T[] array, size_t length) {
    T* ptr = array.ptr;
    if (realloc!T(ptr, T.sizeof * length)) {
        array = ptr[0 .. length];
        return true;
    } else {
        return false;
    }
}

void free(T)(ref T* ptr) {
    lib.free(ptr);
    ptr = null;
}

void freeArray(T)(ref T[] array) {
    lib.free(array.ptr);
    array = null;
}

// --- List

size_t findGoodListCapacity(size_t length) {
    size_t result = defaultListCapacity;
    while (result <= length) {
        result *= 2;
    }
    return result;
}

List!T makeList(T)(size_t capacity) {
    List!T result;
    T[] array = allocArray!T(capacity);
    if (array != null) {
        result.items = array[0 .. 0];
        result.capacity = capacity;
    }
    return result;
}

List!T makeList(T)(inout T[] items) {
    List!T result = makeList!T(findGoodListCapacity(items.length));
    if (result.items != null) {
        result.items[0 .. items.length] = items[0 .. items.length];
    }
    return result;
}

void destroyList(T)(ref List!T l) {
    if (l.items != null) {
        freeArray(l.items);
    }
    l.capacity = 0;
}

size_t length(T)(List!T l) {
    return l.items.length;
}

void setLength(T)(ref List!T l, size_t length) {
    if (length <= l.capacity) {
        l.items = l.items[0 .. length];
    } else {
        size_t capacity = findGoodListCapacity(length);
        if (reallocArray(l.items, capacity)) {
            l.item = l.items[0 .. length];
            l.capacity = capacity;
        }
    }
}

void append(T)(ref List!T l, inout T item) {
    size_t index = l.items.length;
    if (index < l.capacity) {
        l.items = l.items.ptr[0 .. index + 1];
        l.items[index] = cast(T) item;
    } else {
        size_t capacity = findGoodListCapacity(index);
        if (reallocArray(l.items, capacity)) {
            l.items = l.items[0 .. index + 1];
            l.items[index] = cast(T) item;
            l.capacity = capacity;
        }
    }
}

void append(T)(ref List!T l, inout T[] items) {
    foreach (item; items) {
        append(l, item);
    }
}

void remove(T)(ref List!T l, size_t index) {
    if (l.items.length >= 1) {
        l.items[index] = l.items[$ - 1];
        l.items = l.items.ptr[0 .. l.items.length - 1];
    }
}

void removeLast(T)(ref List!T l) {
    remove(l, l.items.length - 1);
}

void removeAndShift(T)(ref List!T l, size_t index) {
    if (l.items.length >= 1) {
        foreach (i; index .. l.items.length - 1) {
            l.items[i] = l.items[i + 1];
        }
        l.items = l.items.ptr[0 .. l.items.length - 1];
    }
}

void clear(T)(ref List!T l) {
    l.items = l.items.ptr[0 .. 0];
}

void clone(T)(ref List!T l) {
    List!T result = makeList!T(l.capacity);
    append(result, l.items);
    return result;
}

unittest {
    int value = 420;
    int* ptr;

    ptr = allocValue(value);
    assert(ptr != null);
    assert(*ptr == value);
    free(ptr);
    assert(ptr == null);
}

unittest {
    size_t count = 69;
    int[] array;

    array = allocArray!int(count);
    assert(array.length == count);
    freeArray(array);
    assert(array == null);
}

unittest {
    int a = 6;
    int b = 9;
    size_t itemCount = 2;
    List!int list;

    assert(list.length == 0);
    list.append(a);
    list.append(b);
    assert(list[0] == a);
    assert(list[1] == b);

    destroyList(list);
    assert(list.length == 0);
}
