<div align="center">
  <img src="assets/images/logo.png" alt="Novon logo" width="120" />
  <h1>Novon</h1>
  <p>An enterprise grade, high performance novel reading engine for the Novon ecosystem.</p>
  <p>
    <img alt="Platform" src="https://img.shields.io/badge/Platform-Flutter-02569B?style=for-the-badge&logo=flutter" />
    <img alt="API Version" src="https://img.shields.io/badge/API-v1-6C63FF?style=for-the-badge" />
    <img alt="Status" src="https://img.shields.io/badge/Status-Alpha-orange?style=for-the-badge" />
    <img alt="License" src="https://img.shields.io/badge/License-Apache%202.0-0877d2?style=for-the-badge" />
  </p>
</div>

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
- [System Architecture](#system-architecture)
- [Codebase Conventions](#codebase-conventions)
- [The Extension Engine Environment](#the-extension-engine-environment)
- [Networking & Scraping Logic](#networking--scraping-logic)
- [Data Persistence & Relational Schema](#data-persistence--relational-schema)
- [Background Maintenance Services](#background-maintenance-services)
- [Project Directory Blueprint](#project-directory-blueprint)
- [Developer Experience & Codegen](#developer-experience--codegen)
- [Security Protocols](#security-protocols)
- [Disclaimer](#disclaimer)
- [Authors & Maintainers](#authors--maintainers)
- [License](#license)

---

## Overview

Novon is a sophisticated, local first reading platform engineered for high fidelity management of long form textual content. Built with **Flutter** and a decentralized **JavaScript driven extension architecture**, it allows users to integrate diverse content sources into a unified, high performance interface.

> [!IMPORTANT]
> **Technical Focus**
>
> The system is designed for high volume metadata management and textual content extraction, utilizing a sandboxed runtime and a relational SQLite database.

## Core Features

- **Local-First Architecture:** Complete offline capability with background synchronization.
- **Dynamic Extensions:** Connect to any content provider through a Sandboxed JS Engine.
- **Enterprise Storage:** High-performance persistence utilizing Drift and Hive.
- **Advanced Networking:** Bypasses basic CDN challenges with intelligent interceptors.
- **Biometric Security:** Encrypted gateways for private reading spaces.

## Getting Started

### Prerequisites
- **Flutter SDK**: `3.x.x` or higher
- **Android Studio** or **VS Code** with corresponding Flutter plugins installed.

### Installation

1. Clone the repository and navigate into the root directory:
   ```bash
   git clone https://github.com/novonapp/novon.git
   cd novon
   ```

2. Retrieve and install the required Dart dependencies:
   ```bash
   flutter pub get
   ```

3. Generate the required source code for Riverpod providers and Drift SQL migrations:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
> [!TIP]
> Run this command whenever you modify files annotated with `@freezed`, `@riverpod`, or any Drift table schemas.

4. Launch the application on a connected device or emulator:
   ```bash
   flutter run
   ```

## System Architecture

Novon implements a modular architecture optimized for enterprise grade maintainability. The application is partitioned into clear technical domains:

### 1. Infrastructure Services (`lib/core/services`)
*   **App Bootstrapping**: Managed by `AppBootstrapper`, which orchestrates the application startup sequence, specifically the handoff between `StoragePathService` and the `AppDatabase` initialization.
*   **Global Lifecycle**: The `AppRuntime` handles system level re-initialization, ensuring global service registries are synchronized during runtime state changes.
*   **Extension Orchestration**: The `ExtensionLoader` manages manifest verification (SHA-256 integrity checks) and semantic versioning (`pub_semver`) to ensure compatibility with the host application.

### 2. Feature Domains (`lib/features`)
Each feature module (e.g., `reader`, `library`) encapsulates its own business logic, state orchestration via generated **Riverpod** providers, and specialized UI components. This ensures modular testability and rapid iteration across domain specific screens.

## Codebase Conventions

Novon strictly adheres to a domain-driven feature-first architecture, separating the application into decoupled modules. 

### Layered Constraints
Every feature module within `lib/features` follows a strict internal triad:
- **`screens/` & `widgets/` (Presentation)**: Pure UI composed of Flutter widgets. These files are structurally forbidden from making direct database or network calls. They strictly watch and react to Riverpod providers.
- **`controllers/` & `providers/` (State)**: The intermediary layer handling business logic. They process user intent, interact with repositories, and expose asynchronous state (`AsyncValue`) to the UI.
- **`repositories/` (Data Lifecycle)**: Defines the boundaries for data acquisition. Repositories abstract over `Dio` (Network) or `Drift/Hive` (Local), ensuring the state layer remains agnostic to the data origin.

### State Management Strategy
The application avoids ephemeral `setState` logic for complex global objects. Instead:
- Global registries and dependency injection are mapped universally via `Riverpod`.
- `AsyncNotifier` classes manage volatile side-effects, such as triggering downloads or executing migrations.
- `StreamProviders` form the backbone of the reactive UI, creating persistent pipelines directly from Drift SQL watchers to the screen, eliminating the need for manual UI synchronization.

## The Extension Engine Environment

The core of Novon's extensibility is a sandboxed JavaScript runtime powered by `flutter_js`.

### Runtime Specifications
The execution environment polyfills a modern JS context to support standard scraping libraries:
*   **Base64 Support**: Integrated `atob` and `btoa` implementations.
*   **Encoding**: Native `TextEncoder` and `TextDecoder` polyfills.
*   **DOM Manipulation**: A custom `parseHtml` wrapper that provides a selectors API for parsing raw HTML buffers.

### Interop Interface
The engine provides an asynchronous JS-to-Dart bridge through `onMessage` channels:
*   `http_get`: Proxies requests to the native `Dio` client for high performance content retrieval.
*   `method_result`: Handles the serialized return of extension calls (`fetchPopular`, `search`, etc.).
*   `console_log`: Redirects JS diagnostics to the native system logs for developer auditing.

## Networking & Scraping Logic

Novon utilizes a high performance `Dio` based networking factory with a sophisticated interceptor pipeline:

### Interceptor Pipeline
*   **RateLimitInterceptor**: Enforces a strict default constraint of **2 requests per second** per host to maintain service stability.
*   **RetryInterceptor**: Automated retry logic for transient network failures.
*   **CookieInterceptor**: Managed persistence for cloudflare session handling and authentication cookies.
*   **Security**: Global `User-Agent` management via Hive settings, ensuring consistent device signatures across all scraping sessions.

## Data Persistence & Relational Schema

The application manages complex relational data through **Drift (SQLite)** and high performance key-value stores in **Hive**.

### Relational Mapping (Drift)
The `AppDatabase` manages several primary tables with strict integrity:

| Table | Description |
| :--- | :--- |
| **`Novels`** | Stores primary metadata, library status, and local tracking flags. |
| **`Chapters`** | Maps novel indices to individual chapter objects, including download status and "last page read" markers. |
| **`History`** | Tracks temporal reading sessions, time spent metrics, and word counts. |
| **`chapter_contents`** | A specialized SQL table for storing raw HTML payloads with pre-indexed meta tracking for performance optimization. |

### Key-Value Storage (Hive)
Hive is used for high-speed access to non-relational settings across three primary boxes:

| Box | Purpose |
| :--- | :--- |
| `HiveBox.app` | Global application configurations and theme tokens. |
| `HiveBox.reader` | Granular reading engine configurations (font sizes, line heights). |
| `HiveBox.extensions` | Extension registries and repository synchronization indices. |

## Background Maintenance Services

Novon leverages the **WorkManager** framework to perform critical system maintenance outside the main execution thread.

### Scheduled Tasks
| Task Name | Task ID | Frequency | Description |
| :--- | :--- | :--- | :--- |
| `taskAutoBackup` | `autoBackupTask` | 24 Hours | Automated parity checks and database backup generation. |
| `taskUpdateLibrary` | `updateLibraryTask` | 06 Hours | Incremental synchronization of library novels for new chapter updates. |
| `taskCheckExtensions` | `checkExtensionsTask` | Routine | Synchronization of repository indices to detect extension updates. |
| `taskPruneLogs` | `pruneLogsTask` | 24 Hours | Automated cleanup of the `ExceptionLoggerService` diagnostic logs. |
| `taskPruneRemovedNovels` | `pruneRemovedNovelsTask` | 12 Hours | Removal of orphaned chapter BLOBs and cover assets for uninstalled novels. |

## Project Directory Blueprint

```text
novon/
├── lib/
│   ├── core/              # Enterprise foundation and system orchestration
│   │   ├── services/      # ExtensionEngine, Bootstrapping, and Migration
│   │   ├── data/          # AppDatabase (Drift), Network Factory, and Repositories
│   │   └── router/        # GoRouter navigation tree via StatefulShellRoute
│   ├── features/          # Encapsulated domain logic and UI modules
│   │   ├── browse/        # Extension discovery and search
│   │   ├── reader/        # High fidelity text rendering engine
│   │   └── security/      # Biometric (local_auth) and PIN gateways
│   ├── runtime/           # App-level lifecycle and re-initialization
│   └── providers/         # Global provider overrides and registries
└── assets/
    ├── js/                # Native JS polyfills for the extension sandbox
    └── fonts/             # Custom typography (Alexandria, El Messiri, Lalezar)
```

## Developer Experience & Codegen

Novon utilizes a generation heavy workflow to ensure type safety across the persistence and state layers.

### Automated Generation
Run the following command to generate the required source code for **Drift**, **Riverpod**, and **Freezed**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Static Analysis
Maintain 100% compliance with the project's strict linting rules before submitting revisions:
```bash
flutter analyze
```

## Security Protocols

Novon prioritizes user data integrity through several structural measures:

> [!WARNING]
> **Data Portability**
> Because Novon is strictly local-first, losing your device without utilizing the automated backup tool will result in permanent loss of your library and histories.

- **Local First Philosophy**: All library data, history, and user settings are stored locally on the device filesystem within the SQLite database. External synchronization is strictly opt-in via third-party trackers.
- **Access Control**: The `AppLockGate` manages biometric authentication and device credential protection for sensitive application areas using `local_auth`.
- **Sandbox Isolation**: Content extraction logic is executed within a memory constrained JavaScript environment, preventing unauthorized access to system APIs or the local filesystem.

## Disclaimer

> [!CAUTION]
> **Legal Disclaimer**
> 
> Novon is an organizational and scraping tool. The developers do not provide, host, or distribute copyrighted content. All content is retrieved dynamically from third-party sources via user-installed extensions.
> 
> Users and extension maintainers are solely responsible for ensuring compliance with intellectual property laws and the Terms of Service of their respective content providers. Use of this software is at your own risk.

## Contributing

We welcome contributions from the community. To maintain the quality of the project, we follow a simple workflow for all changes.

Please note that we do not accept direct pushes to the `main` branch. To contribute, please follow these steps:

1. **Fork the Repository**: Create your own copy of the project.
2. **Create a Branch**: Make your changes in a new branch on your fork.
3. **Open a Pull Request**: Submit your changes for review by opening a pull request against our `main` branch.

All pull requests must receive at least one approval from a maintainer before they can be merged. Thank you for helping improve the Novon ecosystem

## Authors & Maintainers

- **MultiX0** — Lead Developer & Maintainer

## License

Licensed under the Apache License 2.0. See [LICENSE](LICENSE) for the full text.
