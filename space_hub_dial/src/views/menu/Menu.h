#pragma once

#include "../Base.h"

enum class MenuType {
    Main,
    Sub
};

struct MenuSlot {
    int x;
    int y;
};

struct MenuEntry {
    const char* key;  
    IconId icon;
    const char* label;
    uint16_t color;
};

class Menu : public Base {
public:
    void update(AppState& state, const InputState& input) override;
    void render(AppState& state, const InputState& input, DisplayManager& d) override;

    void setItems(const MenuEntry* items, int count, int selectedIndex = 0);
    void setMenuType(MenuType type);

protected:
    void ensureValidIndex();
    void navigate(AppState& state, int delta);

    void renderMainMenu(AppState& state,MenuSlot* slots, DisplayManager& d);
    void renderSubMenu(AppState& state,MenuSlot* slots, DisplayManager& d);

    const MenuEntry* _items = nullptr;
    int _count = 0;
    int _index = 0;
    MenuType _menuType = MenuType::Main;
};