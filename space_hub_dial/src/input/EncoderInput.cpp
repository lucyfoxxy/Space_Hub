#include "EncoderInput.h"
#include <M5Dial.h>

void EncoderInput::setup() {
    _lastValue = M5Dial.Encoder.read();
}

void EncoderInput::update(EncoderData& data) {
    long currentValue = M5Dial.Encoder.read();
    long rawDelta = currentValue - _lastValue;

    _lastValue = currentValue;
    data.raw = currentValue;

    if (rawDelta > 0) {
        data.delta = 1;
    } else if (rawDelta < 0) {
        data.delta = -1;
    } else {
        data.delta = 0;
    }
}