# Daphne (WIP)

A game development library for the D programming language.

The library is designed to be simple and easy to understand.
This means that most of the library avoids using things that tend to make it difficult to read code.
Things like templates and other compile-time features are utilized as little as possible.

## Modules

* daphne.animation
* daphne.dialogue
* daphne.entity
* daphne.math

## Examples

### Math Module

```d
import daphne.math;

void main() {
    auto r0 = Rect(0, 0, 8, 4);
    auto r1 = r0;
    auto r2 = r1.cutSide(Side.right, 4);

    assert(!r1.intersection(r2).isZero);
    assert(r1.merger(r2) == r0);
    assert(r1.point(Anchor.centerRight) == Vec2(r1.x + r1.w, r1.y + r1.h / 2));
}
```

### Animation Module

```d
import daphne.animation;

void main() {
    auto anim = Animation(2);
    anim.frames[0] = Frame(15, 1, &easeInOutSine);
    anim.frames[1] = Frame(30, 2);

    assert(anim.time == 0);
    assert(anim.start == 1);
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

struct Cat {
    int age;
}

void main() {
    auto group = EntityGroup!Cat(4);
    group.append(Cat(3));
    group.append(Cat(7));

    assert(group.length == 4);
    assert(group.entityCount == 2);
    foreach (entity; group.entities) {
        auto cat = group.get(entity);
        cat.age += 1;
        if (cat.age > 12) {
            group.remove(entity);
        }
    }
}
```

## License

The project is released under the terms of the MIT License.
Please refer to the LICENSE file.