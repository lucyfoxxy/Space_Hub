#pragma once

#include "../core/State.h"
#include "../input/InputState.h"
#include "../render/DisplayManager.h"

class Base {
public:
    virtual ~Base() {}

    virtual void update(AppState& state, const InputState& input) = 0;
    virtual void render(AppState& state, const InputState& input, DisplayManager& display) = 0;
};