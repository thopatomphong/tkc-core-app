# Design Spec: Sent Mail Redesign

Refining the Mail screen to fully support a recipient-focused "Sent" view with dynamic headers and status indicators.

## 1. Overview
Building on the recent Inbox redesign, this spec focuses on the "Sent" tab experience. The goal is to match the provided high-fidelity mockup, specifically adding dynamic headers and sent status indicators.

## 2. UI Components

### 2.1. `InboxScreen` (Header Update)
- **Dynamic Title**: The "Inbox" text will change to "Sent" when the second tab is selected.
- **Implementation**: Listen to the `TabController` and update the title string accordingly.

### 2.2. `EmailTile` (Status Indicator)
- **Status Icon**: Add a `Icons.done_all` (double check) icon to the right of the timestamp.
- **Condition**: Only visible when `isSentMode` is `true`.
- **Color**: Material Green `#4CAF50`.
- **Size**: 16pt.

### 2.3. Layout Consistency
- Ensure the divider in the list matches the mockup's `#F1F3F9` color and standard indent (86pt).

## 3. Data Flow
- No changes to existing data providers (`inboxProvider`, `sentMailProvider`).
- The `EmailTile` continues to use the `isSentMode` flag to toggle between Sender/Recipient display and status icon visibility.

## 4. Testing Plan
- **Widget Test (`EmailTile`)**: Verify the double-check icon is visible in `isSentMode` and hidden otherwise.
- **Widget Test (`InboxScreen`)**: Verify the header text changes when the tab is switched.
- **Visual Check**: Ensure the green color matches the mockup's "sent" indicator.
