// Routing primitives and path helpers.
// Describes where the app currently is in the navigation tree.
#pragma once

#include <Arduino.h>
#include <initializer_list>

struct NavigationPath {
    int depth = 0;
    int selected_index = 0;
    const char* segments[4] = { nullptr, nullptr, nullptr, nullptr };
};

inline bool pathEquals(const NavigationPath& a, const NavigationPath& b) {
    if (a.depth != b.depth) return false;
    if (a.selected_index != b.selected_index) return false;

    for (int i = 0; i < 4; i++) {
        const char* sa = a.segments[i];
        const char* sb = b.segments[i];

        if (sa == nullptr && sb == nullptr) continue;
        if (sa == nullptr || sb == nullptr) return false;
        if (strcmp(sa, sb) != 0) return false;
    }

    return true;
}

inline bool pathIs(const NavigationPath& path, std::initializer_list<const char*> segments) {
    int i = 0;

    for (const char* seg : segments) {
        if (i >= path.depth) return false;
        if (path.segments[i] == nullptr) return false;
        if (strcmp(path.segments[i], seg) != 0) return false;
        i++;
    }

    return i == path.depth;
}

inline void setCurrentPath(
    NavigationPath& path,
    std::initializer_list<const char*> segments,
    int selectedIndex = 0
) {
    path.depth = 0;
    path.selected_index = selectedIndex;

    int i = 0;
    for (const char* seg : segments) {
        if (i >= 4) break;
        path.segments[i++] = seg;
        path.depth++;
    }

    while (i < 4) {
        path.segments[i++] = nullptr;
    }
}