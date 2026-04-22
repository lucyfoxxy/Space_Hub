// Runtime application state.
// Holds current navigation and overlay state, but not routing logic.
#pragma once

#include "Routes.h"

struct OverlayState {
    bool active = false;
    NavigationPath path;
};

struct AppState {
    NavigationPath path;
    OverlayState overlay;
};