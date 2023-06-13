# 🦆 Daphne (WIP)

A game development library for the D programming language.

The library is designed to be simple and easy to understand.
This means that the modules in the library are self-contained
and that things like templates and other compile-time features are used as little as possible.
For example, you can simply copy-paste the animation module into your project and start programming.

## 📚 Modules

* daphne.animation
* daphne.dialogue
* daphne.entity
* daphne.math

## 📝 Examples

### Math Module

```d
import daphne.math;

void main() {
    auto r0 = Rect(0, 0, 8, 4);
    auto r1 = r0;
    auto r2 = r1.cutSide(Side.right, 4);

    assert(r1.merger(r2) == r0);
    assert(r1.point(Anchor.centerRight) == Vec2(r1.x + r1.w, r1.y + r1.h / 2));
}
```

### Animation Module

```d
import daphne.animation;

void main() {
    auto frames = [Frame(15, 1), Frame(30, 2)];
    auto anim = Animation(frames);

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
```

### Entity Module

```d
import daphne.entity;

void main() {
    struct Cat {
        int age;
    }

    auto cats = EntityArray!Cat(new Cat[4], new bool[4]);
    assert(cats.length == 4);

    assert(cats.entityCount == 0);
    cats.append(Cat(3));
    cats.append(Cat(7));
    assert(cats.entityCount == 2);

    foreach (entity; cats.entities) {
        auto cat = cats.get(entity);
        cat.age += 1;
        if (cat.age > 7) {
            cats.remove(entity);
        }
    }
    assert(cats.entityCount == 1);
    cats.clear();
    assert(cats.isEmpty);
}
```

## 📎 Contributing

These are the things to keep in mind if you want to write code for the project:

* This is not an object-oriented library.
* The library must be compatible with @nogc.
* Simple solutions are preferred over smart solutions.

## 📌 License

The project is released under the terms of the MIT License.
Please refer to the LICENSE file.
