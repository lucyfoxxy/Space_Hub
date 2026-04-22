#include "DisplayManager.h"

int DisplayManager::width() const { return M5Dial.Display.width(); }
int DisplayManager::height() const { return M5Dial.Display.height(); }
int DisplayManager::centerX() const { return M5Dial.Display.width() / 2; }
int DisplayManager::centerY() const { return M5Dial.Display.height() / 2; }

const char* DisplayManager::resolveIconPath(IconId id) const {
    switch (id) {
        case IconId::Weather: return "/assets/icons/weather.png";
        case IconId::Timer:   return "/assets/icons/timer.png";
        case IconId::Lights:  return "/assets/icons/lights.png";
        case IconId::Media:   return "/assets/icons/media.png";
        case IconId::Debug:   return "/assets/icons/debug.png";
        default: return nullptr;
    }
}

void DisplayManager::setup() {
    M5Dial.Display.setRotation(0);
    _sprite.setColorDepth(24);
    _sprite.createSprite(width(), height());    
}

void DisplayManager::beginFrame() {
    clear(TFT_BLACK);
}

void DisplayManager::endFrame() {
    _sprite.pushSprite(0, 0);
}

void DisplayManager::clear(uint32_t color) {
    _sprite.clear(color);
}

lgfx::LGFX_Sprite& DisplayManager::get() {
    return _sprite;
}

void DisplayManager::drawIcon(IconId id, int cx, int cy, int size) {
    const float scale = (float)size / 256.0f;
    const int t_cx = cx - size / 2;
    const int t_cy = cy - size / 2;

    const char* path = resolveIconPath(id);
    if (!path) return;

    _sprite.drawPngFile(
        SPIFFS,
        path,
        t_cx,
        t_cy,
        96,
        96,
        0,
        0,
        scale,
        scale,
        datum_t::top_left
    );
}

void DisplayManager::writeText(
    const char* text,
    TextPosition position,
    TextSize size,
    int offsetX,
    int offsetY,
    uint16_t color
) {
    auto& d = M5Dial.Display;

    int x = centerX() + offsetX;
    int y = centerY() + offsetY;

    switch (position) {
        case TextPosition::Top:
            y = 40 + offsetY;
            break;
        case TextPosition::Center:
            y = centerY() + offsetY;
            break;
        case TextPosition::Bottom:
            y = height() - 40 + offsetY;
            break;
    }

    switch (size) {
        case TextSize::Small:
            _sprite.setTextSize(1);
            break;
        case TextSize::Medium:
            _sprite.setTextSize(2);
            break;
        case TextSize::Large:
            _sprite.setTextSize(3);
            break;
    }

    _sprite.setTextColor(color);
    _sprite.setTextDatum(middle_center);
    _sprite.drawString(text, x, y);
}

// void DisplayManager::fillVerticalGradient(uint16_t topColor, uint16_t bottomColor) {
//     auto& d = M5Dial.Display;
//     int h = d.height();
//     int w = d.width();

//     for (int y = 0; y < h; y++) {
//         float t = (h <= 1) ? 0.0f : (float)y / (float)(h - 1);
//         uint16_t color = mixColor(topColor, bottomColor, t);
//         d.drawFastHLine(0, y, w, color);
//     }
// }

// void DisplayManager::fillRadialGradient(int cx, int cy, int radius, uint16_t innerColor, uint16_t outerColor) {
//     auto& d = M5Dial.Display;

//     for (int r = radius; r > 0; r--) {
//         float t = (radius <= 1) ? 0.0f : 1.0f - (float)r / (float)radius;
//         uint16_t color = mixColor(outerColor, innerColor, t);
//         d.fillCircle(cx, cy, r, color);
//     }
// }
