#include "InputManager.h"

void InputManager::setup() {
    _encoder.setup();
    _button.setup();
    _touch.setup();
}

void InputManager::update() {
    // nur Frame-Events resetten, bevor neue eingelesen werden
    _state.encoder.delta = 0;
    _state.button.justPressed = false;
    _state.button.justReleased = false;

    _encoder.update(_state.encoder);
    _button.update(_state.button);
    _touch.update(_state.touch);

    // lastDelta nach dem Update stabilisieren
    if (_state.encoder.delta != 0) {
        _state.encoder.lastDelta = _state.encoder.delta;
    }
}

const InputState& InputManager::getState() const {
    return _state;
}