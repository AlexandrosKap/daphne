// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.entity;

alias Entity = size_t;

struct EntityArray(T) {
pure nothrow @nogc @safe:
    T[] components;
    bool[] states;
    Entity lastEntity;

    this(T[] components, bool[] states) {
        if (components.length != states.length) {
            assert(0, "the number of components is not the same as the number of states");
        }
        this.components = components;
        this.states = states;
    }

    size_t length() {
        return states.length;
    }

    size_t entityCount() {
        size_t count;
        foreach (i; 0 .. length) {
            count += states[i];
        }
        return count;
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
            if (entity < lastEntity) {
                lastEntity = entity;
            }
        }
    }

    Entity append(T component) {
        foreach (i; lastEntity .. length) {
            if (!states[i]) {
                components[i] = component;
                states[i] = true;
                lastEntity = i;
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

    auto entities() {
        struct Range {
            bool[] states;
            Entity currentEntity;

            bool empty() {
                return currentEntity >= states.length;
            }

            Entity front() {
                return currentEntity;
            }

            void popFront() {
                currentEntity += 1;
                while (currentEntity < states.length && !states[currentEntity]) {
                    currentEntity += 1;
                }
            }
        }

        Entity startEntity;
        while (startEntity < states.length && !states[startEntity]) {
            startEntity += 1;
        }
        return Range(states, startEntity);
    }
}

unittest {
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
