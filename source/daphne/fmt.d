// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.fmt;

import io = core.stdc.stdio;
import daphne.memory;

nothrow @nogc @trusted:

enum {
    defaultPrintBufferSize = 512,
}

void print(T)(T arg) {
    static if (is(T : string)) {
        if (arg.length < defaultPrintBufferSize) {
            char[defaultPrintBufferSize] buffer = void;
            buffer[0 .. arg.length] = arg[0 .. arg.length];
            buffer[arg.length] = '\0';
            io.printf("%s", buffer.ptr);
        } else {
            char[] buffer = allocArray!char(arg.length + 1);
            buffer[0 .. arg.length] = arg[0 .. arg.length];
            buffer[$ - 1] = '\0';
            io.printf("%s", buffer.ptr);
            freeArray(buffer);
        }
    } else static if (is(T : A[N], A, N) || is(T : A[], A)) {
        if (arg.length == 0) {
            return;
        }
        print('[');
        foreach (item; arg[0 .. $ - 1]) {
            print(item);
            print(", ");
        }
        print(arg[$ - 1]);
        print(']');
    } else static if (is(T == enum)) {
        enum members = __traits(allMembers, T);
        foreach (i, member; members) {
            if (i == arg) {
                print(member);
                break;
            }
        }
    } else static if (is(T == struct)) {
        enum members = __traits(allMembers, T);
        static if (members.length == 0) {
            print("()");
        } else {
            print('(');
            foreach (member; members[0 .. $ - 1]) {
                print(member);
                print(": ");
                print(__traits(getMember, arg, member));
                print(", ");
            }
            print(members[$ - 1]);
            print(": ");
            print(__traits(getMember, arg, members[$ - 1]));
            print(')');
        }
    } else static if (is(T == P*, P)) {
        io.printf("%p", arg);
    } else static if (is(T : bool)) {
        arg ? io.printf("true") : io.printf("false");
    } else static if (is(T : char)) {
        io.printf("%c", arg);
    } else static if (is(T : byte) || is(T : short) || is(T : int)) {
        io.printf("%d", arg);
    } else static if (is(T : long)) {
        io.printf("%ld", arg);
    } else static if (is(T : ubyte) || is(T : ushort) || is(T : uint)) {
        io.printf("%u", arg);
    } else static if (is(T : ulong)) {
        io.printf("%lu", arg);
    } else static if (is(T : float) || is(T : double) || is(T : real)) {
        io.printf("%g", arg);
    } else {
        print('?');
    }
}

void print(T...)(T args) {
    foreach (arg; args) {
        print(arg);
    }
}

void println(T...)(T args) {
    print(args);
    print('\n');
}

unittest {
    struct Position {
        int x, y;
    }

    println(false, true, 420, 6.9, '-', "UwU");
    println(Position(1, 2));
}
