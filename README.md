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

### Ini Module

```d
import daphne.ini;

void main() {
    size_t pairCount = 4;
    string iniFile = `
        # This is my epic player in my epic game.
        [    Player   ]
        name   = Bob
        health = 69

        # This is an epic monster in my epic game.
        [  Monster 1  ]
        name     = Goomba
        position = (420, 20)
    `;

    size_t loopCount;
    auto reader = IniReader(iniFile);
    while (readIniPair(reader) == IniError.none) {
        loopCount += 1;
    }
    assert(loopCount == pairCount);
    assert(reader.groupPairCounter == 2);
}
```

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
    disposeAnimation(animation);
}
```

## 📎 Contributing

These are the things to keep in mind if you want to write code for the project:

- This is not an object-oriented library.
- The library must be compatible with @nogc.
- Simple solutions are preferred over smart solutions.

## 📌 License

The project is released under the terms of the MIT License.
Please refer to the LICENSE file.
