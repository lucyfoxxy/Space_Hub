#pragma once

#include "../Base.h"

class Weather : public Base {
public:
    void update(AppState& state, const InputState& input) override;
    void render(AppState& state, const InputState& input, DisplayManager& display) override;
};