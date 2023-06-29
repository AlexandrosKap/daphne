// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.memory;

import lib = core.stdc.stdlib;

nothrow @nogc @trusted:

enum {
    defaultListCapacity = 64,
}

struct List(T) {
    T[] items;
    size_t capacity;

    ref T opIndex(size_t index) nothrow @nogc @safe {
        return items[index];
    }

    T[] opSlice(size_t index)(size_t a, size_t b) nothrow @nogc @safe {
        return items[a .. b];
    }

    size_t opDollar(size_t index)() nothrow @nogc @safe {
        return items.length;
    }
}

void* alloc(size_t size) {
    return lib.malloc(size);
}

void* realloc(void* ptr, size_t size) {
    return lib.realloc(ptr, size);
}

void free(void* ptr) {
    lib.free(ptr);
}

T* make(T)() {
    return cast(T*) alloc(T.sizeof);
}

T* make(T)(T value) {
    T* ptr = make!T();
    if (ptr != null) {
        *ptr = value;
    }
    return ptr;
}

void dispose(T)(ref T* ptr) {
    if (ptr != null) {
        free(ptr);
        ptr = null;
    }
}

T[] makeArray(T)(size_t length) {
    T* ptr = cast(T*) alloc(T.sizeof * length);
    if (ptr != null) {
        return ptr[0 .. length];
    } else {
        return null;
    }
}

T[] makeArray(T)(T[] value) {
    T[] array = makeArray!T(value.length);
    if (array != null) {
        array[0 .. value.length] = value[0 .. value.length];
    }
    return array;
}

void disposeArray(T)(ref T[] array) {
    if (array != null) {
        free(array.ptr);
        array = null;
    }
}

List!T makeList(T)(size_t capacity = defaultListCapacity) {
    List!T result;
    T[] array = makeArray!T(capacity);
    if (array != null) {
        result.items = array[0 .. 0];
        result.capacity = capacity;
    }
    return result;
}

List!T makeList(T)(T[] items) {
    size_t capacity = defaultListCapacity;
    while (capacity <= items.length) {
        capacity *= 2;
    }
    List!T result = makeList!T(capacity);
    if (result.items != null) {
        result.items[0 .. items.length] = items[0 .. items.length];
    }
}

void disposeList(T)(ref List!T l) {
    disposeArray(l.items);
    l.capacity = 0;
}

size_t length(T)(List!T l) {
    return l.items.length;
}

void setLength(T)(ref List!T l, size_t len) {
    if (len <= l.capacity) {
        l.items = l.items.ptr[0 .. len];
    } else {
        size_t capacity = defaultListCapacity;
        while (capacity <= len) {
            capacity *= 2;
        }
        T* ptr = cast(T*) realloc(l.items.ptr, T.sizeof * capacity);
        if (ptr != null) {
            l.items = ptr[0 .. len];
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
        size_t capacity = defaultListCapacity;
        while (capacity <= index) {
            capacity *= 2;
        }
        T* ptr = cast(T*) realloc(l.items.ptr, T.sizeof * capacity);
        if (ptr != null) {
            l.items = ptr[0 .. index + 1];
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

    ptr = make(value);
    assert(ptr != null);
    assert(*ptr == value);
    dispose(ptr);
    assert(ptr == null);
}

unittest {
    size_t count = 69;
    int[] array;

    array = makeArray!int(count);
    assert(array.length == count);
    disposeArray(array);
    assert(array == null);
}

unittest {
    int a = 6;
    int b = 9;
    size_t itemCount = 2;
    List!int list;

    assert(list.length == 0);
    assert(list.capacity == 0);
    list.append(a);
    list.append(b);
    assert(list.length == itemCount);
    assert(list.capacity == defaultListCapacity);
    assert(list[0] == a);
    assert(list[1] == b);

    list.removeLast();
    assert(list.length == itemCount - 1);
    disposeList(list);
    assert(list.length == 0);
    assert(list.capacity == 0);
}
