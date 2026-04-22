#include "Weather.h"
#include <Arduino.h>


void Weather::update(AppState& state, const InputState& input) {
    if (input.button.justPressed) {
        setCurrentPath(state.path, {"main"});
    }
}

void Weather::render(AppState& state, const InputState& input, DisplayManager& display) {
    auto& d = display.get();

    int cx = d.width() / 2;
    int cy = d.height() / 2;
    int h = d.height();
    int w = d.width();

    for (int y = 0; y < h; y++) {
     // d.drawGradientVLine(0, y, 120, TFT_VIOLET, TFT_PURPLE);
      d.drawGradientHLine(0, y, 480, TFT_VIOLET, TFT_PURPLE);   
    //d.drawGradientLine(0, y, 0, 480, TFT_VIOLET, TFT_PURPLE);
    }

    display.writeText("Weather",TextPosition::Top,TextSize::Large);
    display.writeText("Sunny",TextPosition::Top,TextSize::Medium,0,28);
    display.drawIcon(IconId::Weather,120,160,64);

}