#pragma once

#include "../core/State.h"
#include "../views/detail/Weather.h"
#include "../views/menu/Main.h"
#include "../views/detail/Debug.h"
#include "../input/InputManager.h"
#include "../render/DisplayManager.h"

class App {
public:
    void setup();
    void update();

private:
    void updateCurrentView();
    void renderCurrentView();

    AppState _state;
    unsigned long _lastRender = 0;
    bool _needsRender = true;

    NavigationPath _last_path;
    MainMenu _mainMenu;
    Weather _weather;
    Debug _debug;

    InputManager _input;
    DisplayManager _display;
};