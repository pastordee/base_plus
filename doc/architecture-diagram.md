# Native iOS Tab Bar Architecture Diagram

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         BaseTabBar                              │
│                 (Cross-Platform Tab Bar)                        │
│                                                                 │
│  Properties:                                                    │
│  • useNativeCupertinoTabBar: bool (default: true)              │
│  • items: List<BottomNavigationBarItem>                        │
│  • onTap: ValueChanged<int>?                                   │
│  • currentIndex: int                                           │
│  • enableLiquidGlass, hapticFeedback, etc.                     │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
         ┌──────────────┴──────────────┐
         │    Platform Detection        │
         │   (via Theme.of(context))    │
         └──────────────┬──────────────┘
                        │
        ┌───────────────┴────────────────┐
        │                                │
        ▼                                ▼
┌───────────────┐              ┌─────────────────┐
│  iOS Platform │              │ Other Platforms │
│               │              │  (Android, Web) │
└───────┬───────┘              └────────┬────────┘
        │                               │
        ▼                               ▼
┌──────────────────────┐      ┌────────────────────┐
│ useNativeCupertino   │      │  Material Design   │
│      TabBar?         │      │ BottomNavigation   │
└───┬────────┬─────────┘      │       Bar          │
    │        │                └────────────────────┘
  true     false                      │
    │        │                        │
    │        └────────────────────────┘
    │                                 │
    ▼                                 ▼
┌────────────────────────┐   ┌──────────────────┐
│ _buildNativeCupertino  │   │  Material Theme  │
│       TabBar()         │   │  with enhanced   │
│                        │   │  visual states   │
│ 1. Extract items       │   └──────────────────┘
│ 2. Convert to          │
│    CNTabBarItem        │
│ 3. Return CNTabBar     │
└───────┬────────────────┘
        │
        ▼
┌─────────────────────────────────────────────┐
│         SF Symbol Extraction Flow           │
│                                             │
│  For each BottomNavigationBarItem:         │
│                                             │
│  ┌─────────────────────────────┐          │
│  │ 1. Check icon widget type   │          │
│  └────────────┬────────────────┘          │
│               │                            │
│               ▼                            │
│  ┌─────────────────────────────┐          │
│  │   Is KeyedSubtree?          │          │
│  └───┬─────────────────┬───────┘          │
│      │YES              │NO                 │
│      ▼                 ▼                   │
│  ┌─────────────┐  ┌──────────────┐       │
│  │ Extract key │  │  Is Icon?    │       │
│  │ BaseNative  │  └───┬──────────┘       │
│  │ TabBarItem  │      │YES    │NO        │
│  │    Key?     │      ▼       ▼          │
│  └───┬─────────┘  ┌────────┐ ┌─────┐    │
│      │YES  │NO    │ _map   │ │ Use │    │
│      ▼     │      │IconTo  │ │ 'ci│    │
│  ┌────┐   │      │SFSymb  │ │rcle │    │
│  │Use │   │      │ol()    │ │.fill│    │
│  │SF  │   │      └───┬────┘ │'    │    │
│  │Sym │   │          │      └─────┘    │
│  │bol │   │          ▼                  │
│  │Name│   └─────►┌────────┐            │
│  └────┘          │CNSymbol│            │
│                  │ (icon) │            │
│                  └────────┘            │
└─────────────────────────────────────────┘
                   │
                   ▼
        ┌──────────────────────┐
        │    CNTabBarItem      │
        │                      │
        │ • label: String      │
        │ • icon: CNSymbol     │
        └──────────────────────┘
                   │
                   ▼
        ┌──────────────────────┐
        │      CNTabBar        │
        │  (Native iOS 26)     │
        │                      │
        │ • Liquid Glass       │
        │ • SF Symbols         │
        │ • Haptic Feedback    │
        └──────────────────────┘
```

## SF Symbol Specification Methods

```
┌──────────────────────────────────────────────────────────────┐
│           Method 1: Convenience Factory                      │
│                   (Recommended)                              │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  BottomNavigationBarItemNativeExtension.withSFSymbol(       │
│    sfSymbolName: SFSymbols.home,                            │
│    icon: Icon(Icons.home_outlined),                         │
│    label: 'Home',                                           │
│  )                                                          │
│                                                              │
│  ↓ Creates:                                                 │
│                                                              │
│  BottomNavigationBarItem(                                   │
│    icon: KeyedSubtree(                                      │
│      key: BaseNativeTabBarItemKey('house.fill'),           │
│      child: Icon(Icons.home_outlined),                      │
│    ),                                                       │
│    label: 'Home',                                           │
│  )                                                          │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│          Method 2: KeyedSubtree with Metadata                │
│                   (More Control)                             │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  BottomNavigationBarItem(                                   │
│    icon: KeyedSubtree(                                      │
│      key: BaseNativeTabBarItemKey(SFSymbols.search),       │
│      child: Icon(Icons.search_outlined),                    │
│    ),                                                       │
│    label: 'Search',                                         │
│  )                                                          │
│                                                              │
│  ↓ BaseTabBar extracts:                                     │
│                                                              │
│  key.sfSymbolName → 'magnifyingglass'                       │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│            Method 3: Automatic Icon Mapping                  │
│                 (No Configuration)                           │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  BottomNavigationBarItem(                                   │
│    icon: Icon(Icons.person_outline),                        │
│    label: 'Profile',                                        │
│  )                                                          │
│                                                              │
│  ↓ BaseTabBar maps:                                         │
│                                                              │
│  Icons.person_outline (0xe491)                              │
│    → _mapIconToSFSymbol()                                   │
│    → 'person.crop.circle'                                   │
└──────────────────────────────────────────────────────────────┘
```

## Icon Mapping System

```
┌─────────────────────────────────────────────────────────┐
│            _mapIconToSFSymbol() Method                  │
│                                                         │
│  Input: IconData (Material icon)                       │
│  Output: String (SF Symbol name)                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  static const Map<int, String> _iconToSFSymbolMap = {  │
│    0xe318: 'house.fill',           // Icons.home       │
│    0xe567: 'magnifyingglass',      // Icons.search     │
│    0xe491: 'person.crop.circle',   // Icons.person     │
│    0xe57f: 'gearshape.fill',       // Icons.settings   │
│    0xe237: 'heart.fill',           // Icons.favorite   │
│    // ... 20+ more mappings                            │
│  };                                                     │
│                                                         │
│  Method:                                                │
│  1. Extract icon.codePoint from IconData               │
│  2. Lookup in _iconToSFSymbolMap                       │
│  3. Return mapped SF Symbol name                       │
│  4. Fallback: 'circle.fill' if not found              │
└─────────────────────────────────────────────────────────┘
```

## Class Hierarchy

```
BaseStatelessWidget
    ↑
    │
BaseTabBar
    │
    ├── Properties
    │   ├── items: List<BottomNavigationBarItem>
    │   ├── onTap: ValueChanged<int>?
    │   ├── currentIndex: int
    │   ├── useNativeCupertinoTabBar: bool
    │   ├── enableLiquidGlass: bool
    │   ├── hapticFeedback: bool
    │   └── ... more properties
    │
    ├── Methods
    │   ├── build(BuildContext)
    │   ├── _buildNativeCupertinoTabBar()
    │   ├── _mapIconToSFSymbol(IconData?)
    │   └── ... platform-specific builders
    │
    └── Dependencies
        ├── cupertino_native (CNTabBar, CNTabBarItem, CNSymbol)
        ├── base_native_tab_bar_item.dart
        └── flutter/material.dart

┌───────────────────────────────────────────┐
│   Helper Classes (base_native_tab_bar    │
│              _item.dart)                  │
├───────────────────────────────────────────┤
│                                           │
│  BaseNativeTabBarItemKey                 │
│  extends ValueKey<String>                │
│    ├── sfSymbolName: String              │
│    └── Constructor(String)               │
│                                           │
│  BottomNavigationBarItemNative           │
│           Extension                       │
│    └── static withSFSymbol(...)          │
│        Returns: BottomNavigationBarItem  │
│                                           │
│  SFSymbols (Constants)                   │
│    ├── home: 'house.fill'                │
│    ├── search: 'magnifyingglass'         │
│    ├── profile: 'person.crop.circle'     │
│    └── ... 30+ more constants            │
└───────────────────────────────────────────┘
```

## Data Flow

```
User Interaction
    │
    ▼
┌──────────────────┐
│  BaseTabBar      │
│  items: [...]    │
└────────┬─────────┘
         │
         ▼
┌──────────────────────────────┐
│ Platform Detection           │
│ (iOS with useNativeCupertino │
│  TabBar: true)               │
└────────┬─────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│ _buildNativeCupertinoTabBar()     │
│                                    │
│ For each item in items:            │
│   1. Extract SF Symbol name        │
│   2. Create CNTabBarItem           │
│   3. Add to list                   │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│ SF Symbol Extraction Logic         │
│                                    │
│ ┌────────────────────────────┐   │
│ │ KeyedSubtree?              │   │
│ └──┬───────────────────┬─────┘   │
│    │YES                │NO        │
│    ▼                   ▼          │
│ ┌─────────┐      ┌──────────┐   │
│ │Extract  │      │ Icon?    │   │
│ │metadata │      └──┬───┬───┘   │
│ └─────────┘         │YES│NO     │
│                     ▼   ▼       │
│              ┌─────────┐ ┌────┐ │
│              │Map icon │ │Use │ │
│              │to SF    │ │def │ │
│              │Symbol   │ │ault│ │
│              └─────────┘ └────┘ │
└────────┬───────────────────────┘
         │
         ▼
┌────────────────────────┐
│ List<CNTabBarItem>     │
│                        │
│ [CNTabBarItem(         │
│   label: 'Home',       │
│   icon: CNSymbol(...)  │
│ ), ...]                │
└────────┬───────────────┘
         │
         ▼
┌────────────────────────┐
│ CNTabBar(              │
│   items: [...],        │
│   currentIndex: 0,     │
│   onTap: (i) {...}     │
│ )                      │
└────────┬───────────────┘
         │
         ▼
┌────────────────────────┐
│ Native iOS 26 Tab Bar  │
│ with SF Symbols        │
│ + Haptic Feedback      │
│ + Liquid Glass Effects │
└────────────────────────┘
```

## Component Integration

```
┌───────────────────────────────────────────────────────────┐
│                    Flutter Base Package                   │
│                                                           │
│  ┌─────────────────────────────────────────────────┐    │
│  │              base_widgets.dart                   │    │
│  │                                                  │    │
│  │  exports:                                        │    │
│  │  • src/tabbar/base_bar_item.dart                │    │
│  │  • src/tabbar/base_native_tab_bar_item.dart ✨   │    │
│  │  • src/tabbar/base_tab_bar.dart                 │    │
│  └─────────────────────────────────────────────────┘    │
│                                                           │
│  ┌─────────────────────────────────────────────────┐    │
│  │       src/tabbar/base_tab_bar.dart              │    │
│  │                                                  │    │
│  │  • BaseTabBar widget                            │    │
│  │  • useNativeCupertinoTabBar property ✨          │    │
│  │  • _buildNativeCupertinoTabBar() method ✨       │    │
│  │  • _mapIconToSFSymbol() method ✨                │    │
│  │  • iOS 26 Liquid Glass effects                  │    │
│  │  • Cross-platform support                       │    │
│  └─────────────────────────────────────────────────┘    │
│                                                           │
│  ┌─────────────────────────────────────────────────┐    │
│  │   src/tabbar/base_native_tab_bar_item.dart ✨    │    │
│  │                                                  │    │
│  │  • BaseNativeTabBarItemKey                      │    │
│  │  • BottomNavigationBarItemNativeExtension       │    │
│  │  • SFSymbols (30+ constants)                    │    │
│  └─────────────────────────────────────────────────┘    │
└───────────────────────┬───────────────────────────────────┘
                        │
                        │ imports
                        │
                        ▼
┌───────────────────────────────────────────────────────────┐
│              cupertino_native: ^0.1.1                     │
│                                                           │
│  • CNTabBar (Native iOS tab bar)                         │
│  • CNTabBarItem (Tab bar item)                           │
│  • CNSymbol (SF Symbol wrapper)                          │
│  • CNButton, CNSwitch, CNSlider, etc.                    │
└───────────────────────────────────────────────────────────┘

✨ = New additions for native iOS integration
```

## Legend

```
┌─────┐
│ Box │  = Component/Class
└─────┘

  │
  ▼      = Data flow / Relationship

┌──┐
│▼ │    = Decision point / Conditional
└──┘

┌───────────────────┐
│ Dashed border     │  = External package
└───────────────────┘

✨       = New feature/component
```
