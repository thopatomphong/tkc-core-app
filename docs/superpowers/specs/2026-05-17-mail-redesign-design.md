# Design Spec: Inbox Redesign

Implementing a high-fidelity, tabbed inbox interface with a modern layout, specialized avatars, and a recipient-focused sent mail view.

## 1. Overview
The current `InboxScreen` is a simple list. This redesign transforms it into a professional mail portal matching the provided mockup, featuring a large header, a red compose action, and a segmented toggle for Inbox/Sent views.

## 2. UI Components

### 2.1. `InboxScreen` (Container)
- **Header**: Large "Inbox" title (32pt, Bold).
- **Compose Button**: Circular FAB (Material Red `#F44336`) with a white edit icon, positioned in the top right.
- **Tab Bar**: A custom segmented control styled toggle.
    - Background: Light grey `#F1F3F9`.
    - Active State: White card with soft shadow.
    - Labels: "Inbox" and "Sent".
- **Body**: `TabBarView` to switch between `MailListView` instances.

### 2.2. `MailListView` (Reusable List)
- Hosts the `RefreshIndicator` and `ListView.builder`.
- Takes a `Provider` and a `bool isSentMode`.
- Handles loading/error states using standard project patterns.

### 2.3. `EmailTile` (Atomic Widget)
- **Leading**: `CircleAvatar`
    - Initials: 2 characters (e.g., "U2" or "S").
    - Background: Generated from `username.hashCode` using a curated palette.
- **Top Row**: 
    - Name (Bold, 16pt).
    - Timestamp (Grey, 13pt, right-aligned, e.g., "Just now", "2m ago").
- **Subject**: Bold, 15pt, max 1 line with ellipsis.
- **Body Preview**: Grey, 14pt, max 1 line with ellipsis.
- **Layout**: 16px vertical padding, 20px horizontal padding.

## 3. Data Flow
- **Inbox Tab**: Watches `inboxProvider`. Displays `senderUsername`.
- **Sent Tab**: Watches `sentMailProvider`. Displays `recipientUsername` (prefixed with "To: ").
- **Navigation**:
    - Tap Tile -> `context.go('/mail/${email.id}')`.
    - Tap Compose -> `context.go('/mail/compose')`.

## 4. Technical Details
- **Colors**:
    - Avatar Palette: Blue `#1976D2`, Green `#388E3C`, Amber `#FFA000`, Deep Orange `#E64A19`, Purple `#7B1FA2`.
- **Time Formatting**: Use a utility to convert `DateTime` to relative strings ("2m ago", "1h ago").

## 5. Testing Plan
- **Widget Tests**:
    - `EmailTile`: Verify avatar initials and color generation.
    - `EmailTile`: Verify "To: " prefix appears correctly in Sent mode.
    - `InboxScreen`: Verify tab switching triggers different provider watches.
    - `InboxScreen`: Verify FAB navigates to compose screen.
