# Design Spec - Home Screen Redesign

Redesign the application's entry point to a high-fidelity Home Screen with a modern tabbed navigation structure.

## 1. Overview
The goal is to replace the current `LauncherScreen` (which acts as an inbox placeholder) with a dedicated `HomeScreen` that serves as a portal to "Mini Apps" and other core features. This change introduces a `StatefulShellRoute` navigation system to provide a seamless tabbed experience (Home, Mail, Profile).

## 2. Navigation Architecture

### Routing Strategy
- **Package:** `go_router`
- **Implementation:** `StatefulShellRoute.indexedStack`
- **Shell Widget:** `LauncherScreen`
- **Branches:**
  - **Home Branch:** Initial location `/home`. Hosts `HomeScreen`.
  - **Mail Branch:** Initial location `/mail`. Hosts `InboxScreen`.
  - **Profile Branch:** Initial location `/profile`. Hosts `ProfileScreen`.

### Bottom Navigation Bar
- **Tabs:**
  - **Home:** Icon `Icons.home`, Label "Home".
  - **Mail:** Icon `Icons.mail`, Label "Mail".
  - **Profile:** Icon `Icons.person`, Label "Profile".
- **Styling:** Material 3 `NavigationBar` or custom `BottomNavigationBar` matching the design's clean aesthetic (white background, red active color).

## 3. Visual Design (Home Screen)

### Header
- **Greeting:** "Good morning," (Top, light gray) followed by "[User Name]" (Large, Bold, Black).
- **Avatar:** Circular container (approx 44x44px) with background color `#D32F2F` and white initials.
- **Interaction:** Tapping the avatar navigates to the Profile tab.

### Body Content
- **Background:** Subtle light gray/blueish color (`#F1F3F9`) to contrast with white cards.
- **Section Title:** "Mini Apps" (Bold, 20px).
- **Mini App Cards:**
  - **Layout:** Grid or flexible row of cards.
  - **Card Styling:** White background, 20px border radius, soft multi-layered shadows.
  - **Card Content:**
    - Icon in a colored square with rounded corners (14px).
    - Title (Bold, 16px).
    - Description (Regular, 13px, Gray).
  - **Apps:**
    - **Shopping:** Blue icon (`#1E88E5`), "Browse & order products". Navigates to `/shopping`.
    - **Concert:** Orange icon (`#FFB300`), "Book concert tickets". Navigates to `/concert`.

## 4. Components & Widgets

### New Widgets
- **`HomeScreen`**: The primary view for the Home tab.
- **`MiniAppCard`**: A reusable component for the app tiles.
- **`HomeHeader`**: Component for the welcome greeting and avatar.

### Refactored Widgets
- **`LauncherScreen`**: Updated to serve as the `Shell` for `StatefulShellRoute`.
- **`AppRouter`**: Updated with the new `StatefulShellRoute` configuration.

## 5. State Management
- **User Data:** Use `profileProvider` to fetch and display the user's name and initials.
- **Navigation State:** Managed by `GoRouter`'s `StatefulNavigationShell`.

## 6. Testing Strategy
- **Widget Tests:**
  - Verify `HomeScreen` displays correct greeting and avatar.
  - Verify `MiniAppCard` elements are present and interactive.
  - Verify `LauncherScreen` correctly renders the bottom navigation bar.
- **Integration Tests:**
  - Verify switching between tabs maintains state (e.g., scroll position in Mail).
  - Verify navigation from cards to respective mini-apps.
