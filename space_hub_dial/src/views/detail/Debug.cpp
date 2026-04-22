#include "Debug.h"
#include <M5Dial.h>

struct ColorEntry {
    const char* name;
    uint16_t color;
};

static const ColorEntry COLORS[] = {
    { "RED",          TFT_RED },
    { "ORANGE",       TFT_ORANGE },
    { "YELLOW",       TFT_YELLOW },
    { "GREENYELLOW",  TFT_GREENYELLOW },
    { "GREEN",        TFT_GREEN },
    { "DARKGREEN",    TFT_DARKGREEN },
    { "CYAN",         TFT_CYAN },
    { "DARKCYAN",     TFT_DARKCYAN },
    { "SKYBLUE",      TFT_SKYBLUE },
    { "BLUE",         TFT_BLUE },
    { "NAVY",         TFT_NAVY },
    { "VIOLET",       TFT_VIOLET },
    { "PURPLE",       TFT_PURPLE },
    { "MAGENTA",      TFT_MAGENTA },
    { "PINK",         TFT_PINK },
    { "MAROON",       TFT_MAROON },
    { "BROWN",        TFT_BROWN },
    { "GOLD",         TFT_GOLD },
    { "SILVER",       TFT_SILVER },
    { "LIGHTGREY",    TFT_LIGHTGREY },
    { "DARKGREY",     TFT_DARKGREY }
};

static const int COLOR_COUNT = sizeof(COLORS) / sizeof(ColorEntry);

void Debug::update(AppState& state, const InputState& input) {
    if (input.button.justPressed) {
        setCurrentPath(state.path, {"main"});
    }
}

void Debug::render(AppState& state, const InputState& input, DisplayManager& display) {
    auto& d = display.get();

    int w = d.width();
    int h = d.height();

    int lineH = h / COLOR_COUNT;
    if (lineH < 6) lineH = 6; // safety

    for (int i = 0; i < COLOR_COUNT; i++) {
        int y = i * lineH;

        // Farbfläche
        d.fillRect(0, y, w, lineH, COLORS[i].color);

        // Textfarbe abhängig vom Hintergrund
        uint16_t textColor = TFT_WHITE;
        if (COLORS[i].color == TFT_YELLOW ||
            COLORS[i].color == TFT_GREENYELLOW ||
            COLORS[i].color == TFT_GREEN ||
            COLORS[i].color == TFT_LIGHTGREY ||
            COLORS[i].color == TFT_CYAN ||
            COLORS[i].color == TFT_GOLD) {
            textColor = TFT_BLACK;
        }

        display.writeText(COLORS[i].name, TextPosition::Center, TextSize::Small, -8, (y + lineH / 2)-h/2, textColor);
    }
}