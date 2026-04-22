#pragma once
#include "InputTypes.h"

// Gesamter Input-Zustand pro Frame
struct InputState {
    EncoderData encoder;
    ButtonData button;
    TouchData touch;
};