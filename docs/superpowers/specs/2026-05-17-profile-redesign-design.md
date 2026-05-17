# Design Spec: Profile Screen Redesign

**Date:** 2026-05-17
**Topic:** High-fidelity redesign of the Profile screen to match the provided mockup.

## 1. Goal
Redesign the current `ProfileScreen` into a high-fidelity, polished interface with a card-based layout, status indicators, and custom-styled interaction tiles.

## 2. Architecture & Components

### Component Breakdown
- **`ProfileScreen` (Container)**: The main screen widget, using a `Scaffold` with background color `#F1F3F9`. It orchestrates the list of sections.
- **`ProfileHeader`**: 
    - Large initials avatar (e.g., "U1") with `#D32F2F` background.
    - Display Name (Bold, Black).
    - Username (@username, Gray).
    - Email (Link-style, Blue).
    - Status Badge: Pill-shaped, light green background, dark green text with a dot icon ("Online").
- **`ProfileSection`**: A wrapper widget providing a white container with `BorderRadius.circular(20)`, soft shadows, and an optional header label (e.g., "ACCOUNT").
- **`ProfileTile`**: 
    - Icon Container: Rounded-rect background with specific color.
    - Title: Bold black text.
    - Value: Gray text.
    - Trailing: Small gray chevron (`>`).
- **`SignOutButton`**: A wide white button with rounded corners and centered red "Sign Out" text.

### File Organization
```text
lib/features/profile/
├── widgets/
│   ├── profile_header.dart
│   ├── profile_section.dart
│   ├── profile_tile.dart
│   └── sign_out_button.dart
└── profile_screen.dart (Updated)
```

## 3. Visual Styling

### Design Tokens
- **Background**: `#F1F3F9`
- **Card Color**: White (`#FFFFFF`)
- **Card Radius**: 20px
- **Shadow**: Soft, multi-layered drop shadows.
- **Icon Container Radius**: 8px-12px.
- **Colors**:
    - Avatar/Sign Out: `#D32F2F`
    - Display Name Icon: `#1E88E5`
    - Email Icon: `#43A047`
    - Push Notifications Icon: `#FFB300`
    - WebSocket Icon: `#1E88E5`
    - Status Dot: Colors.green

## 4. Data & State Management
- Use `profileProvider` (Riverpod) to fetch user data.
- Use `authControllerProvider` for the "Sign Out" action.
- Status indicators (Push/WebSocket) will be read-only placeholders ("Enabled", "Connected") matching the mockup for this phase.

## 5. Testing Strategy
- **Widget Tests**: Verify that `ProfileScreen` renders all sections and displays correct user data (initials, display name, email).
- **Golden Tests**: (Optional/Manual) Ensure the visual layout matches the mockup.
- **Interactions**: Verify the "Sign Out" button triggers the `AuthController.logout()` method.
