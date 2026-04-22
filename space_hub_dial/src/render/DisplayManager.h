#pragma once

#include <Arduino.h>
#include <SPIFFS.h>
#include <M5Dial.h>

enum class IconId {
    Weather,
    Timer,
    Lights,
    Media,
    Debug
};

enum class TextPosition {
    Top,
    Center,
    Bottom
};

enum class TextSize {
    Small,
    Medium,
    Large
};

class DisplayManager {
public:
    void setup();
    void beginFrame();
    void endFrame();

    void clear(uint32_t color = 0);

    int width() const;
    int height() const;
    int centerX() const;
    int centerY() const;

    lgfx::LGFX_Sprite& get();

    void drawIcon(
        IconId id,
        int cx,
        int cy,
        int scale = 38
    );

    void writeText(
        const char* text,
        TextPosition position = TextPosition::Center,
        TextSize size = TextSize::Medium,
        int offsetX = 0,
        int offsetY = 0,
        uint16_t color = TFT_WHITE
    );

private:
    const char* resolveIconPath(IconId id) const;
    LGFX_Sprite _sprite{&M5Dial.Display};
};