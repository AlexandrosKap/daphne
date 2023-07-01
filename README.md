# 🦆 Daphne (WIP)

A game development library for the D programming language.

The library is designed to be simple and easy to understand.
This means that most of the library modules are self-contained and that things like templates and other compile-time features are used as little as possible.

## 📚 Modules

* daphne.animation
* daphne.fmt
* daphne.ini
* daphne.math
* daphne.memory
* daphne.optional

## 📝 Examples

### Animation Module

```d
import daphne.animation;

void main() {
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
    destroyAnimation(animation);
}
```

### Ini Module

```d
import daphne.animation;

void main() {
    enum pairCount = 4;
    enum iniFile = `
        # This is my epic player in my epic game.
        [    Player   ]
        name   = Bob
        health = 69

        # This is an epic monster in my epic game.
        [  Monster 1  ]
        name     = Goomba
        position = (420, 20)
    `;

    auto i = 0;
    auto reader = makeIniReader(iniFile);
    while (reader.readIniPair() == IniError.none) {
        i += 1;
    }
    assert(i == pairCount);
    assert(reader.groupPairCounter == 2);
}
```

### Math Module

```d
import daphne.animation;

void main() {
    auto r0 = Rect(0, 0, 8, 4);
    auto r1 = r0;
    auto r2 = r1.cutSide(Side.right, 4);

    assert(merger(r1, r2) == r0);
    assert(r1.point(Anchor.centerRight) == Vec2(r1.x + r1.w, r1.y + r1.h / 2));
}
```

## 🎨 Daphne Style

The Daphne Style is a set of style conventions for writing D programs.

* Structures are recommended to be POD.
* Constructor procedures start with `make`.
* Destructor procedures start with `destroy`.
* Memory-related procedures start with `alloc`, `realloc` and `free`.
* Memory-related procedures should always return a pointer or a slice.

## 📎 Contributing

These are the things to keep in mind if you want to write code for the project:

- This is not an object-oriented library.
- The library must be compatible with @nogc @safe.
- Simple solutions are preferred over smart solutions.

## 📌 License

The project is released under the terms of the MIT License.
Please refer to the LICENSE file.
