#include "ButtonInput.h"
#include <M5Dial.h>

void ButtonInput::setup() {
    _lastPressed = false;
}

void ButtonInput::update(ButtonData& data) {
    bool currentPressed = M5Dial.BtnA.isPressed();

    data.pressed = currentPressed;
    data.justPressed = (!_lastPressed && currentPressed);
    data.justReleased = (_lastPressed && !currentPressed);

    _lastPressed = currentPressed;
}