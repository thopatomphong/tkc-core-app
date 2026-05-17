# Design Spec - Login Screen Implementation

Implement a polished, high-fidelity Login Screen for the TKC Mail application based on Figma design specifications.

## 1. Overview
The goal is to replace the current basic Material 3 `LoginScreen` with a custom-styled implementation that matches the "Mock Mail" design. The implementation will focus on precise layout, gradients, and shadows as specified in the Figma CSS.

## 2. Visual Design

### Colors & Gradients
- **Background:** White (`#FFFFFF`)
- **Logo Gradient:** `linear-gradient(135deg, #4285F4 0%, #34A853 100%)`
- **Button Gradient:** `linear-gradient(135deg, #EA4335 0%, #C5221F 100%)`
- **Button Shadow:** `0px 4px 16px rgba(234, 67, 53, 0.3)`
- **Input Background:** `#FAFAFA`
- **Input Border:** `#E0E0E0` (1px solid)
- **Text Primary:** `#1A1A1A`
- **Text Secondary:** `#888888`
- **Labels:** `#555555`

### Typography
- **Font Family:** System Fonts (matches Helvetica Neue style)
- **App Title:** 28px, Bold (700), Color `#1A1A1A`
- **Subtitle:** 15px, Regular (400), Color `#888888`
- **Labels:** 13px, Uppercase, Letter Spacing 0.5px, Color `#555555`
- **Input Text:** 16px, Regular (400), Color `#BBBBBB` (placeholder/default)
- **Button Text:** 17px, Regular (400), Color `#FFFFFF`

### Layout & Spacing
- **Container:** Maximum width 393px (centered on screen)
- **Logo:** 80x80px, 20px border radius
- **Inputs:** 337x52px, 12px border radius, 16px internal padding
- **Button:** 337x53px, 12px border radius
- **Vertical Spacing:**
  - Top to Logo: 80px
  - Logo to Title: 20px
  - Title to Subtitle: 8px
  - Subtitle to Username Label: 128px (approximate based on Figma top positioning)
  - Label to Input: 8px
  - Field to Field: 20px
  - Field to Button: 32px

## 3. Architecture & Components

### Widgets
- **`LoginScreen`**: Main entry point, uses `HookConsumerWidget`.
- **`LogoWidget`**: Custom widget with `BoxDecoration` and `LinearGradient`.
- **`CustomTextField`**: Reusable component for Username/Password with specific styling for borders and background.
- **`PrimaryButton`**: Custom button with `LinearGradient` and `BoxShadow`.

### State Management
- Continue using `authControllerProvider` for login logic.
- Use `useTextEditingController` for input handling.

## 4. Implementation Details
- Use `Container` with `BoxDecoration` for gradients and shadows.
- Use `InputDecoration.collapsed` or `OutlineInputBorder` with `borderSide: BorderSide.none` to achieve the custom input look.
- Wrap inputs in `Column` with `CrossAxisAlignment.start` for label placement.
- Use `SafeArea` and `SingleChildScrollView` to handle different screen sizes and keyboard overlays.

## 5. Testing Strategy
- **Widget Tests:**
  - Verify logo and text elements are present.
  - Verify input fields exist and accept text.
  - Verify "Sign In" button triggers the auth controller.
- **Visual Regression:** Manually verify against the original mockup image.
