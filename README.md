# iOS Take-Home Assignment

## Overview

You are tasked with building a **Universal Server-Driven UI Pinterest-style Feed** for iOS. This assignment is designed to evaluate your SwiftUI skills, architectural thinking, and problem-solving abilities.

⚠️ Please read entire `README.md` before starting.

**Estimated Time:** 8-12 hours

**Deadline:** Within 5 days of receiving the assignment. If circumstances arise and you need more time, don't hesitate to reach out.

---

## Getting Started

This repository contains a template Xcode project with pre-registered custom fonts for your use.

**Clone the repository:**
```bash
git clone https://github.com/phiadev/iOS-Take-Home.git
cd PhiaOnsiteDemo
```

Open the `.xcodeproj` file in Xcode and build upon the provided template.

**Design Reference:** [FIGMA LINK](https://www.figma.com/design/Q1C5CWcu4x8vXiS1tXD9Mh/Phia-iOS-Takehome?node-id=0-1&p=f&t=OKZkdwJxwaVwWdcy-0)

Refer to the Figma design for a 1:1 implementation of the UI, including card layouts, variants, spacing, typography, and colors.

---

## Technical Requirements

### Stack (Required)
- **SwiftUI** - All UI must be built using SwiftUI
- **Deployment Target:** iOS 18+
- **Concurrency:** Swift's native `async/await` 
- **Networking:** `URLSession` (no third-party networking libraries)
- **State Management:** `@Observable` macro (no Combine, no `ObservableObject`, no `@Published`)

### Core Features

1. **Server-Driven UI**
   - **Required:** Support 3 card types: `ProductCard`, `OutfitCard`, `EditorialCard`
   - **Required:** Implement `PRIMARY` variant for each card type
   - **Bonus:** Implement `SECONDARY` and `TERTIARY` variants (see Figma)

2. **Pinterest-Style Layout**
   - Staggered/masonry grid (2 columns)
   - Dynamic card heights based on content
   - Smooth scrolling performance

3. **Infinite Scroll with Pagination**
   - Load more content as user scrolls
   - Handle loading states appropriately

4. **Navigation & Detail View**
   - Tapping a card navigates to a detail page
   - Detail page must display all model data in an organized manner
   - Design is optional but encouraged (see Figma)

5. **Authentication & Error Handling**
   - Include Bearer token for `/api/v2` endpoints
   - Handle network failures and authentication errors gracefully

---

## API Information

**Base URL:** `http://35.193.245.204`

**Endpoints:**
- `GET /api/explore/feed` - Public feed (no auth)
- `GET /api/v2/explore/feed` - Authenticated feed

**Authentication:**
```
Authorization: Bearer phia-interview-token
```

**Query Parameters:**
- `offset` (int, default=0)
- `limit` (int, default=20)

**Interactive API Docs:** `http://35.193.245.204/docs`

Explore the API docs to understand the response structure and test the endpoints.

---

## AI Usage Policy

### ⚠️ Strictly Prohibited
- GitHub Copilot
- ChatGPT or Claude for code generation
- Any IDE AI completion features
- AI code snippet generators

**Any submission using AI-generated code will be automatically rejected.**

### Allowed
- Understanding concepts or documentation
- Debugging strategies (without sharing your code)
- General iOS development questions

### Code Attribution Required
If you reference external sources (Stack Overflow, Apple Documentation, blogs), cite them:
```swift
// Source: [URL or description]
// Adapted from Stack Overflow answer by [user] - [link]
```

---

## Deliverables

1. **Xcode Project** - Complete, runnable project (iOS 18+)
2. **README.md** - Architectural decisions, instructions, assumptions, trade-offs, bonus features implemented
3. **Code Comments** - Citations for external code, explanations for complex logic

---

## Evaluation Criteria

- **Code Quality** - Clean, readable code with proper separation of concerns
- **SwiftUI & iOS Skills** - Effective patterns, proper use of `@Observable`, `async/await`, navigation, pagination
- **Architecture** - Server-driven UI, scalability, data modeling, authentication
- **Problem-Solving** - Layout implementation, error handling, smooth UX

**Bonus Points:** Additional variants, polished detail view, edge case handling, performance optimizations

---

## Submission

Submit as:
- Git repository (GitHub, GitLab, etc.) with commit history, OR
- ZIP file containing the Xcode project

Include `README.md` in the root directory.

---

## Questions?

Reach out to `etienne@phia.com` for clarification.

Good luck! We're excited to see your resourcefulness and problem-solving skills.
