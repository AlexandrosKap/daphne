// Copyright (c) 2023 Alexandros F. G. Kapretsos
// Distributed under the MIT License, see LICENSE file.

module daphne.ini;

nothrow @nogc @safe:

enum IniError {
    none,
    eof,
    invalidLine,
    invalidGroup,
    invalidKey,
}

struct IniReader {
    // File data
    string content;

    // Pair data
    string group;
    string key;
    string value;
    size_t lineNumber;

    // If isLazy is true, then groups and keys can have almost any character.
    bool isLazy;
}

string _strip(string s) {
    string result = s;
    while (result.length != 0 && (result[0] == ' ' || result[0] == '\t')) {
        result = result[1 .. $];
    }
    while (result.length != 0 && (result[$ - 1] == ' ' || result[$ - 1] == '\t')) {
        result = result[0 .. $ - 1];
    }
    return result;
}

bool isIniGroupChar(char c) {
    return c != '[' && c != ']';
}

bool isIniKeyChar(char c) {
    return c == '-' || c == '_' ||
        (c >= 'a' && c <= 'z') ||
        (c >= 'A' && c <= 'Z') ||
        (c >= '0' && c <= '9');
}

IniError readIniPair(ref IniReader r) {
    if (r.content.length == 0) {
        return IniError.eof;
    }
    // Get current line.
    string line;
    bool isLastLine = true;
    foreach (i, c; r.content) {
        if (c == '\n') {
            isLastLine = false;
            line = r.content[0 .. i];
            r.lineNumber += 1;
            if (i + 1 < r.content.length) {
                r.content = r.content[i + 1 .. $];
            } else {
                r.content = r.content[i .. $];
            }
            break;
        }
    }
    if (isLastLine) {
        line = r.content;
        r.content = "";
    }
    line = _strip(line);
    // Read current line.
    if (line.length == 0 || line[0] == '#' || line[0] == ';') {
        return readIniPair(r);
    } else if (line[0] == '[') {
        if (line[$ - 1] != ']') {
            return IniError.invalidGroup;
        }
        string group = _strip(line[1 .. $ - 1]);
        if (!r.isLazy) {
            foreach (c; group) {
                if (!isIniGroupChar(c)) {
                    return IniError.invalidGroup;
                }
            }
        }
        r.group = group;
        return readIniPair(r);
    } else {
        foreach (i, c; line) {
            if (c == '=' && i + 1 < line.length) {
                string key = _strip(line[0 .. i]);
                string value = _strip(line[i + 1 .. $]);
                if (key.length == 0 || value.length == 0) {
                    return IniError.invalidLine;
                }
                if (!r.isLazy) {
                    foreach (cc; key) {
                        if (!isIniKeyChar(cc)) {
                            return IniError.invalidKey;
                        }
                    }
                }
                r.key = key;
                r.value = value;
                return IniError.none;
            }
        }
        return IniError.invalidLine;
    }
}

unittest {
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
}
