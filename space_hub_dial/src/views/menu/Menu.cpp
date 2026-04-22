#include "libraries/M5GFX/src/lgfx/v1/misc/enum.hpp"
#include "Menu.h"
#include "../../render/DisplayManager.h"
#include <math.h>

void Menu::renderMainMenu(AppState& state, MenuSlot* slots, DisplayManager& d) {
    // 5 Entry Radial View
    const int cx = d.centerX();
    const int cy = d.centerY();
    const int radius = 82;
    const float startDeg = -90.0f;
    const float stepDeg = 72.0f;
    const float degToRad = 3.14159265f / 180.0f;
    d.get().fillCircle(120,120,120,TFT_BLUEVIOLET);
    for (int i = 0; i < 5; i++) {
        float angle = (startDeg + stepDeg * i) * degToRad;
        slots[i].x = cx + (int)roundf(cosf(angle) * radius);
        slots[i].y = cy + (int)roundf(sinf(angle) * radius);
        const MenuSlot& slot = slots[i];
        const MenuEntry& item = _items[i];
        bool selected = (i == state.path.selected_index);
        if (selected) {
            d.get().fillCircle(slot.x, slot.y, 30, TFT_MAGENTA); 
        } else {
            //d.get().fillCircle(slot.x, slot.y, 27, TFT_PURPLE);
        }

        if (selected) {
            d.drawIcon(item.icon, slot.x, slot.y, 39);
        } else {
            d.drawIcon(item.icon, slot.x, slot.y, 37);
        }
    }

    d.writeText(_items[_index].label, TextPosition::Center, TextSize::Medium);
}

void Menu::renderSubMenu(AppState& state, MenuSlot* outSlots, DisplayManager& d) {
    // Placeholder for Submenu
}

void Menu::setItems(const MenuEntry* items, int count, int selectedIndex) {
    _items = items;
    _count = count;
    _index = selectedIndex;
    ensureValidIndex();
}

void Menu::ensureValidIndex() {
    if (_count <= 0) { _index = 0; return;}
    if (_index < 0) _index = 0;
    if (_index >= _count) _index = _count - 1;
}

void Menu::setMenuType(MenuType type) {
    _menuType = type;
}

void Menu::update(AppState& state, const InputState& input) {
    if (_count <= 0 || _items == nullptr) return;

    state.path.selected_index = _index;

    if (input.button.justPressed) {
        navigate(state, 0);
    } else if (input.encoder.delta > 0) {
        navigate(state, 1);
    } else if (input.encoder.delta < 0) {
        navigate(state, -1);
    }

    // TODO:
    // Touch handling should resolve the tapped entry and treat it like navigate(state, 0)
    // for the selected/tapped menu item.

}

void Menu::render(AppState& state, const InputState& input, DisplayManager& d) {
    
    if (_menuType == MenuType::Main) {
        MenuSlot slots[5];
        renderMainMenu(state, slots, d);
    } else {
        MenuSlot slots[10]; 
        renderSubMenu(state, slots, d);
    }

}

void Menu::navigate(AppState& state, int delta) {
    if (_count <= 0 || _items == nullptr) {
        setCurrentPath(state.path, {"main"});
        return;
    }

    if (delta > 0) {
        _index++;
        if (_index >= _count) _index = 0;
        state.path.selected_index = _index;
        return;
    }

    if (delta < 0) {
        _index--;
        if (_index < 0) _index = _count - 1;
        state.path.selected_index = _index;
        return;
    }

    // delta == 0 -> selektierten key an den path anhängen
    if (state.path.depth < 4) {
        state.path.segments[state.path.depth] = _items[_index].key;
        state.path.depth++;
        state.path.selected_index = 0;
    }
}