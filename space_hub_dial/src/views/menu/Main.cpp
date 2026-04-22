#include "Main.h"

static const MenuEntry MAIN_MENU_ITEMS[] = {
    { "weather", IconId::Weather, "Weather", TFT_NAVY },
    { "timer",   IconId::Timer,   "Timer",   TFT_PURPLE },
    { "lights",  IconId::Lights,  "Lights",  TFT_VIOLET },
    { "media",   IconId::Media,   "Media",   TFT_MAGENTA },
    { "debug",   IconId::Debug,   "Debug",   TFT_MAROON },
};

static const int MAIN_MENU_COUNT = sizeof(MAIN_MENU_ITEMS) / sizeof(MenuEntry);

MainMenu::MainMenu() {
    setMenuType(MenuType::Main);
    setItems(MAIN_MENU_ITEMS, MAIN_MENU_COUNT);
}