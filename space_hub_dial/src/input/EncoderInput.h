#pragma once

#include "InputTypes.h"

class EncoderInput {
public:
    void setup();
    void update(EncoderData& data);

private:
    long _lastValue = 0;
};