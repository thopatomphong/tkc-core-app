# Design Spec: Compose Email Redesign

Redesign the `ComposeScreen` to match a high-fidelity, native-inspired iOS aesthetic with a componentized architecture and functional toolbar.

## Architecture & Components

The screen will be refactored into focused private widgets to maintain a clean `build` method and improve maintainability.

- **`_ComposeHeader`**: 
  - Custom `AppBar` mimic.
  - Left: "Cancel" (text button, `0xFFFF3B30`).
  - Center: "New Email" (bold title).
  - Right: "Send" button (red background `0xFFE53935`, white text/icon).

- **`_RecipientSection`**:
  - Horizontal layout with "To:" label (`0xFF8E8E93`).
  - Uses `Wrap` to display `InputChip` widgets for each recipient.
  - Includes a borderless `TextField` to add new recipients.

- **`_SubjectSection`**:
  - Horizontal layout with "Subject:" label (`0xFF8E8E93`).
  - Single-line borderless `TextField`.

- **`_BodyArea`**:
  - Large, scrollable, borderless `TextField`.
  - Expands to fill available space.
  - Default text style for premium readability.

- **`_FormattingToolbar`**:
  - Sticky footer above the keyboard.
  - Top Row (Optional/Conditional): Formatting controls (B, I, U, Lists) visible when "T" is toggled.
  - Bottom Row: Fixed icons for Text (T), Phone, and Chat.

## Data Flow & State Management

Using `flutter_hooks` for local UI state:
- `recipients`: `ValueNotifier<List<String>>` for chip management.
- `subjectController`: `TextEditingController`.
- `bodyController`: `TextEditingController`.
- `isFormattingActive`: `ValueNotifier<bool>` to toggle the formatting bar.

### Validation
- "Send" button is enabled only if `recipients` is not empty.

## Styling & Design Tokens

- **Colors**:
  - Action Red: `0xFFE53935`
  - Cancel Red: `0xFFFF3B30`
  - Label Grey: `0xFF8E8E93`
  - Chip Background: `0xFFEEF2F7`
  - Border Color: `0xFFEEEEEE`
- **Typography**:
  - Title: Bold, 17px equivalent.
  - Labels: 16px, grey.
  - Body: 17px, black.

## Testing Strategy

- **Widget Tests**:
  - Verify "Cancel" pops the route.
  - Verify recipients can be added as chips.
  - Verify "T" icon toggles the formatting bar.
  - Verify "Send" is disabled without recipients.
  - Verify "Send" calls the repository with all recipients.
