# Design Spec: Mail Detail Redesign

**Date:** 2026-05-17
**Status:** Pending Review

## Overview
Redesign the `EmailDetailScreen` to match a specific "Order Receipt" mockup. The screen will transition from a standard list-based layout to a more polished, componentized UI with a structured receipt card.

## Goals
- Modernize the Mail Detail view.
- Implement a visually distinct "Receipt Card" for order-related emails.
- Ensure the UI matches the provided mockup precisely (static implementation for now).

## Architecture & Components

The screen will be broken down into the following private widgets within `lib/features/mail/email_detail_screen.dart`:

### 1. `_EmailHeader`
- **Purpose:** Displays the email subject and sender information.
- **Styling:**
  - Subject: `Theme.of(context).textTheme.headlineMedium` (Bold, black).
  - Sender Row: Custom row with:
    - `CircleAvatar`: Background color `Colors.redAccent`, white text.
    - `Column`: Sender name (bold) and "To: [recipient] · [time]" (gray, smaller).

### 2. `_ReceiptCard`
- **Purpose:** The main content area showing order details.
- **Styling:**
  - Background: `Color(0xFFF8F9FA)` (Light gray).
  - Border Radius: `12.0`.
  - Padding: `EdgeInsets.all(20)`.
- **Internal Sections:**
  - **Title:** Centered `Row` with "🧾 Order Receipt" text.
  - **Divider:** A thin horizontal line.
  - **Line Items:** List of `_ReceiptItem` widgets.
  - **Total:** Bold row with "Total" and price in red (`Color(0xFFE53935)`).
  - **Timestamp:** Centered `Text` at the bottom (gray, small).

### 3. `_ReceiptItem`
- **Purpose:** Represents a single line item in the receipt.
- **Layout:** `Row` with:
  - `Column` (Left): Item name and quantity (e.g., "× 2").
  - `Text` (Right): Price.

## Design Tokens

| Token | Value |
|-------|-------|
| Primary Red | `Color(0xFFE53935)` |
| Card Background | `Color(0xFFF8F9FA)` |
| Text Gray | `Colors.grey[600]` |
| Avatar Color | `Colors.redAccent` |

## Data Flow
- Currently, the implementation will use **hardcoded data** matching the mockup for the receipt items.
- The `EmailDetailScreen` will still receive an `emailId` and watch the `emailDetailProvider`, but the body display will be replaced by the static receipt card.

## Verification Plan
- **Visual Check:** Verify the screen matches `sent_mail_mockup.png` (or the provided reference).
- **Navigation:** Ensure the "Back" button (Inbox) works correctly.
- **Responsiveness:** Test on different screen sizes to ensure the card margins and padding look correct.
