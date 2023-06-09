// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.entity;

alias Entity = size_t;

struct EntityGroup(T) {
pure nothrow @nogc @safe:
    T[] components;
    bool[] states;
    Entity last;

    this(T[] components, bool[] states) {
        if (components.length != states.length) {
            assert(0, "the number of components must be equal to the number of states");
        }
        this.components = components;
        this.states = states;
    }

    size_t length() {
        return components.length;
    }

    bool isEmpty() {
        return entityCount == 0;
    }

    bool isFull() {
        return entityCount == length;
    }

    bool has(Entity entity) {
        return entity < length && states[entity];
    }

    T* get(Entity entity) {
        if (has(entity)) {
            return &components[entity];
        } else {
            return null;
        }
    }

    void remove(Entity entity) {
        if (has(entity)) {
            states[entity] = false;
            if (entity < last) {
                last = entity;
            }
        }
    }

    Entity append(T component) {
        foreach (i; last .. length) {
            if (!states[i]) {
                components[i] = component;
                states[i] = true;
                last = i;
                return i;
            }
        }
        return Entity.max;
    }

    void clear() {
        foreach (i; 0 .. length) {
            states[i] = false;
        }
    }

    size_t entityCount() {
        size_t count;
        foreach (i; 0 .. length) {
            count += states[i];
        }
        return count;
    }

    auto entities() {
        struct Range {
            T[] components;
            bool[] states;
            Entity entity;

            this(T[] components, bool[] states, Entity entity) {
                this.components = components;
                this.states = states;
                this.entity = entity;
            }

            bool empty() {
                return entity >= components.length;
            }

            Entity front() {
                return entity;
            }

            void popFront() {
                entity += 1;
                while (entity < components.length) {
                    if (states[entity]) {
                        break;
                    }
                    entity += 1;
                }
            }
        }

        size_t start;
        while (start < length) {
            if (states[start]) {
                break;
            }
            start += 1;
        }
        return Range(components, states, start);
    }
}

unittest {
    struct Cat {
        int age;
    }

    auto group = EntityGroup!Cat(new Cat[4], new bool[4]);
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
