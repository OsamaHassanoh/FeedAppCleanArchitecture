Feed Application - Clean Architecture iOS App

A production-ready iOS feed application built with Clean Architecture, MVVM, and SOLID principles. Features SwiftUI for modern UI, comprehensive unit testing, and professional network layer implementation.

✨ Features

1. Clean Architecture with clear separation of concerns
2. MVVM Pattern for maintainable code
3. Dependency Injection for testability
4. Unit Tests with 80% code coverage
5. Image Caching using Kingfisher
6. Async/await for modern concurrency
7. SwiftUI for declarative UI
8. Theme Support with custom color schemes
9. Section Filtering for content organization
10. Error Handling with retry mechanisms


🏛️ Architecture
This project follows Clean Architecture principles with three distinct layers:
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (Views, ViewModels, UI Components)     │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│          Domain Layer                   │
│   (Entities, UseCases, Protocols)       │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│           Data Layer                    │
│  (DTOs, Repositories, Network, Mappers) │
└─────────────────────────────────────────┘
Layer Responsibilities
📱 Presentation Layer

Views: SwiftUI views for UI rendering
ViewModels: State management and business logic coordination
Components: Reusable UI components

🎯 Domain Layer

Entities: Core business models (independent of frameworks)
Use Cases: Business logic implementation
Protocols: Abstractions for dependency inversion

💾 Data Layer

DTOs: Data Transfer Objects for API responses
Repositories: Data access and persistence
Mappers: DTO ↔ Entity transformations
Network: API communication and error handling

## 🗂️ Project Structure
```
FeedAppCleanArchitecture/
│
├── Core/                                    # Shared infrastructure
│   ├── DI/
│   │   ├── AppDIContainer.swift            # Root container
│   │   └── DIContainer.swift               # Base protocol
│   │
│   ├── Network/
│   │   ├── NetworkService.swift
│   │   ├── NetworkError.swift
│   │   └── APIEndpoints.swift
│   │
│   ├── Theme/
│   │   ├── AppTheme.swift
│   │   ├── Colors.swift
│   │   └── Typography.swift
│   │
│   └── Helpers/
│       ├── Extensions/
│       │   ├── String+Extensions.swift
│       │   └── Date+Extensions.swift
│       └── Utilities/
│           ├── Logger.swift
│           └── Validator.swift
│
└── Features/                                # All features
    │
    ├── Feed/                                # Feed Feature
    │   ├── Data/
    │   │   ├── DTO/
    │   │   │   ├── FeedResponseDTO.swift
    │   │   │   ├── PostDTO.swift
    │   │   │   └── UserDTO.swift
    │   │   │
    │   │   ├── Endpoints/
    │   │   │   └── FeedEndpoint.swift
    │   │   │
    │   │   ├── Mappers/
    │   │   │   └── FeedMapper.swift
    │   │   │
    │   │   └── Repository/
    │   │       └── FeedRepository.swift
    │   │
    │   ├── Domain/
    │   │   ├── Entities/
    │   │   │   ├── FeedSectionEntity.swift
    │   │   │   ├── PostEntity.swift
    │   │   │   └── UserEntity.swift
    │   │   │
    │   │   ├── Protocols/
    │   │   │   └── FeedRepoProtocol.swift
    │   │   │
    │   │   └── UseCase/
    │   │       ├── FetchFeedsUseCase.swift
    │   │       └── LikePostUseCase.swift
    │   │
    │   ├── Presentation/
    │   │   ├── FeedView.swift
    │   │   ├── FeedViewModel.swift
    │   │   └── Components/
    │   │       ├── PostCard.swift
    │   │       └── SectionSelector.swift
    │   │
    │   └── DI/
    │       └── FeedDIContainer.swift        # Feature DI
    │
    ├── Account/                             # Account Feature
    │   ├── Data/
    │   │   ├── DTO/
    │   │   │   ├── LoginDTO.swift
    │   │   │   └── UserDTO.swift
    │   │   │
    │   │   ├── Endpoints/
    │   │   │   └── AuthEndpoint.swift
    │   │   │
    │   │   └── Repository/
    │   │       └── AuthRepository.swift
    │   │
    │   ├── Domain/
    │   │   ├── Entities/
    │   │   │   └── User.swift
    │   │   │
    │   │   ├── Protocols/
    │   │   │   └── AuthRepoProtocol.swift
    │   │   │
    │   │   └── UseCase/
    │   │       ├── LoginUseCase.swift
    │   │       ├── RegisterUseCase.swift
    │   │       └── LogoutUseCase.swift
    │   │
    │   ├── Presentation/
    │   │   ├── LoginView.swift
    │   │   ├── LoginViewModel.swift
    │   │   ├── RegisterView.swift
    │   │   └── RegisterViewModel.swift
    │   │
    │   └── DI/
    │       └── AccountDIContainer.swift
    │
    ├── Profile/                             # Profile Feature
    │   ├── Data/
    │   │   ├── DTO/
    │   │   ├── Endpoints/
    │   │   └── Repository/
    │   │
    │   ├── Domain/
    │   │   ├── Entities/
    │   │   ├── Protocols/
    │   │   └── UseCase/
    │   │
    │   ├── Presentation/
    │   │   ├── ProfileView.swift
    │   │   ├── ProfileViewModel.swift
    │   │   └── Components/
    │   │
    │   └── DI/
    │       └── ProfileDIContainer.swift
    │
    └── Settings/                            # Settings Feature
        ├── Data/
        │   ├── DTO/
        │   ├── Endpoints/
        │   └── Repository/
        │
        ├── Domain/
        │   ├── Entities/
        │   ├── Protocols/
        │   └── UseCase/
        │
        ├── Presentation/
        │   ├── SettingsView.swift
        │   └── SettingsViewModel.swift
        │
        └── DI/
            └── SettingsDIContainer.swift

---

📦 Dependencies
This project uses Swift Package Manager (SPM) for dependency management.
Third-Party Libraries
LibraryVersionPurpose   "Kingfisher7.x"  Async image downloading and caching


## 🧪 Testing

Comprehensive unit tests covering all layers of the application.

### Test Coverage
```
Total Tests: 13
Passed: 13 ✅
Failed: 0
Coverage: ~80%

