#include "App.h"
#include <Arduino.h>

#include <SPIFFS.h>
#include <M5Dial.h>

void App::setup() {
    auto cfg = M5.config();

    M5Dial.begin(cfg, true, false);
    Serial.begin(115200);
    SPIFFS.begin(true);

    _input.setup();
    _display.setup();
    setCurrentPath(_state.path, {"main"});
    Serial.println("[App] setup complete");
}

void App::update() {
    M5Dial.update();

    unsigned long now = millis();

    _input.update();
    const InputState& input = _input.getState();

    // Input → Render trigger
    if (input.encoder.delta != 0 ||
        input.button.justPressed ||
        input.button.justReleased ||
        input.touch.touched) {
        _needsRender = true;
    }

    updateCurrentView();

    // View change → Render trigger
    if (!pathEquals(_state.path, _last_path)) {
         _last_path = _state.path;
        _needsRender = true;
    }

    if (_needsRender) {
        renderCurrentView();
        _needsRender = false;
    }
}

void App::updateCurrentView() {
    const InputState& input = _input.getState();

    if (_state.overlay.active) {
        // TODO: overlay routing
        return;
    }

    if (pathIs(_state.path, {"main"})) {
        _mainMenu.update(_state, input);
        return;

    } else if (pathIs(_state.path, {"main","weather"})) {
        _weather.update(_state, input);
        return;

    } else if (pathIs(_state.path, {"main","debug"})) {
        _debug.update(_state, input);
        return;

    } else {
        // TODO: timer / lights / media
        _mainMenu.update(_state, input);
        return;
    }
}

void App::renderCurrentView() {
    const InputState& input = _input.getState();

    _display.beginFrame();

    if (_state.overlay.active) {
        // TODO: overlay rendering
        _display.endFrame();
        return;
    }

    if (pathIs(_state.path, {"main"})) {
        _mainMenu.render(_state, input, _display);

    } else if (pathIs(_state.path, {"main","weather"})) {
        _weather.render(_state, input, _display);

    } else if (pathIs(_state.path, {"main","debug"})) {
        _debug.render(_state, input, _display);

    } else {
        // TODO: timer / lights / media
        _mainMenu.render(_state, input, _display);
    }

    _display.endFrame();
}