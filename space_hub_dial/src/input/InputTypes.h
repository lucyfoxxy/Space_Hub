#pragma once

struct EncoderData {
    int delta = 0;
    int lastDelta = 0;
    long raw = 0;
};

struct ButtonData {
    bool pressed = false;
    bool justPressed = false;
    bool justReleased = false;
};

struct TouchData {
    bool touched = false;
};