#pragma once

#include "InputState.h"
#include "EncoderInput.h"
#include "ButtonInput.h"
#include "TouchInput.h"

class InputManager {
public:
    void setup();
    void update();

    const InputState& getState() const;

private:
    InputState _state;

    EncoderInput _encoder;
    ButtonInput _button;
    TouchInput _touch;
};