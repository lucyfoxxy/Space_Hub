#include "TouchInput.h"
#include <M5Dial.h>

void TouchInput::setup() {
}

void TouchInput::update(TouchData& data) {
    auto detail = M5Dial.Touch.getDetail();
    data.touched = detail.isPressed();
}