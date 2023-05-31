// License: MIT | See LICENSE file in repo.

module daphne.config;

alias Num = float;
alias EasingFunc = Num function(Num x) pure nothrow @nogc @safe;

pure nothrow @nogc @safe {
    Num linear(Num x) {
        return x;
    }
}

unittest {
    assert(linear(420) == 420);
}
