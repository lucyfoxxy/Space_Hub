#pragma once

#include "InputTypes.h"

class ButtonInput {
public:
    void setup();
    void update(ButtonData& data);

private:
    bool _lastPressed = false;
};