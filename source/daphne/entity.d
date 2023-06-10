// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.entity;

alias Entity = size_t;

// NOTE: Maybe check if "isActive" is a boolean.
struct EntityGroup(T) if (__traits(hasMember, T, "isActive")) {
pure nothrow @nogc @safe:
    T[] components;
    Entity lastEntity;

    this(T[] components) {
        this.components = components;
    }

    size_t length() {
        return components.length;
    }

    size_t entityCount() {
        size_t count;
        foreach (i; 0 .. length) {
            count += components[i].isActive;
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
        return entity < length && components[entity].isActive;
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
            components[entity].isActive = false;
            if (entity < lastEntity) {
                lastEntity = entity;
            }
        }
    }

    Entity append(T component) {
        foreach (i; lastEntity .. length) {
            if (!components[i].isActive) {
                components[i] = component;
                components[i].isActive = true;
                lastEntity = i;
                return i;
            }
        }
        return Entity.max;
    }

    void clear() {
        foreach (i; 0 .. length) {
            components[i].isActive = false;
        }
    }

    auto entities() {
        struct Range {
            T[] components;
            Entity currentEntity;

            bool empty() {
                return currentEntity >= components.length;
            }

            Entity front() {
                return currentEntity;
            }

            void popFront() {
                currentEntity += 1;
                while (currentEntity < components.length && !components[currentEntity].isActive) {
                    currentEntity += 1;
                }
            }
        }

        Entity startEntity;
        while (startEntity < components.length && !components[startEntity].isActive) {
            startEntity += 1;
        }
        return Range(components, startEntity);
    }
}

unittest {
    struct Cat {
        int age;
        bool isActive;
    }

    auto group = EntityGroup!Cat(new Cat[4]);
    assert(group.length == 4);

    assert(group.entityCount == 0);
    group.append(Cat(3));
    group.append(Cat(7));
    assert(group.entityCount == 2);

    foreach (entity; group.entities) {
        auto cat = group.get(entity);
        cat.age += 1;
        if (cat.age > 7) {
            group.remove(entity);
        }
    }
    assert(group.entityCount == 1);
    group.clear();
    assert(group.isEmpty);
}
