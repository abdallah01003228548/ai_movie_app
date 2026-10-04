# Architecture Guidelines — AI Movie App

> **Binding standard.** Every new feature built in this project must follow these rules.
> Reference this file in future prompts as: *"follow ARCHITECTURE.md"*.

---

## 1. Folder Structure — Clean Architecture

Every feature lives under `lib/{feature}/` and **must** have these sub-folders:

```
lib/{feature}/
├── data/
│   ├── models/          # Pure Dart DTOs — no Flutter imports
│   ├── services/        # External API / SDK clients (TMDB, Firebase SDK wrappers)
│   └── repositories/   # Repository implementations — orchestrate services, throw typed exceptions
└── presentation/
    ├── cubit/           # Cubit class + sealed State class
    ├── pages/           # Full-screen StatelessWidget / StatefulWidget
    └── widgets/         # Reusable sub-widgets for this feature
```

**Rules:**
- `data/` files **must not** import `package:flutter/...`.
- `presentation/` files **must not** import `dio`, `firebase_auth`, `http`, or any data-source SDK directly.
- Repository interfaces (if used) live in `data/repositories/`; implementations live alongside them.
- Cross-feature shared code (network client, theme, DI, routes) lives in `lib/core/`.

---

## 2. State Management — Cubit + Sealed States

Every feature with **async** or **non-trivial** state must use a `Cubit`.

### Standard state pattern

```dart
sealed class FeatureState {}
class FeatureInitial  extends FeatureState {}
class FeatureLoading  extends FeatureState {}
class FeatureLoaded   extends FeatureState { final Data data; FeatureLoaded(this.data); }
class FeatureError    extends FeatureState { final String message; FeatureError(this.message); }
```

**Rules:**
- ❌ No `FutureBuilder` driving business logic in a widget.
- ❌ No `setState` for "is this async call loading/done/failed" — that must be a Cubit state.
- ✅ `setState` is allowed **only** for trivial local UI state (e.g. `obscureText` toggle on a password field).
- Use `BlocBuilder` / `BlocConsumer` / `BlocListener` to react to state in the UI.

---

## 3. Dependency Injection — GetIt Service Locator

**Central registration file:** `lib/core/di/service_locator.dart`

```dart
final getIt = GetIt.instance;

void setupServiceLocator() {
  // Services (lazy singletons — one instance for the app lifetime)
  getIt.registerLazySingleton<TmdbService>(() => TmdbService());

  // Repositories (lazy singletons)
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // Cubits (factories — fresh instance per screen)
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
}
```

**Rules:**
- ✅ Call `setupServiceLocator()` in `main()` before `runApp()`.
- ✅ Resolve via `getIt<T>()` — in `BlocProvider.create`, in `StatefulWidget.initState`, or anywhere outside a widget's `build` method.
- ❌ Never write `SomeService()` or `SomeRepository()` **inside a widget or `BlocProvider.create`**. The only place constructors are called is inside `service_locator.dart` itself (and inside unit tests).
- Use `registerLazySingleton` for services and repositories (shared, long-lived).
- Use `registerFactory` for Cubits (each screen gets its own fresh instance).

---

## 4. No Logic in UI Widgets

A widget file is **only** allowed to:
1. Read user input (text fields, taps).
2. Call a Cubit method: `context.read<MyCubit>().doSomething(input)`.
3. React to Cubit state via `BlocBuilder` / `BlocConsumer` / `BlocListener`.

**Rules:**
- ❌ No `FirebaseAuth.instance.*` calls inside a widget method.
- ❌ No `TmdbService().*` calls inside a widget method.
- ❌ No error-message switch/case inside a widget — that mapping lives in the Cubit or Repository.
- ✅ Simple local validation (e.g. "fields must not be empty") may stay in the widget as a guard before calling the Cubit, **or** be delegated to the Cubit — your choice, but no Firebase/API call ever.

---

## 5. Responsive Design

**Rules:**
- ❌ No hardcoded pixel widths/heights for containers that hold scaled content (cards, carousels, nav bar).
- ✅ Use `MediaQuery.of(context).size` for percentage-based sizing.
- ✅ Use `Flexible` / `Expanded` inside `Row`/`Column` instead of fixed-width children.
- ✅ Wrap form `Column`s in `SingleChildScrollView` so the keyboard never causes overflow.
- ✅ Use `LayoutBuilder` when a widget's layout depends on its parent's constraints.
- Fixed sizes are acceptable **only** for small icons, avatar circles, and design-system tokens that intentionally never scale (e.g. a 4 px divider).

---

## 6. Quick Reference — "Does my new screen comply?"

| Check | Where it must live |
|---|---|
| `FirebaseAuth` call | `AuthRepository` in `auth/data/repositories/` |
| `TmdbService` call | Cubit, which receives the service via constructor |
| Error message mapping | Cubit or Repository, never the widget |
| `SomeService()` constructor | Only in `service_locator.dart` |
| Loading / success / error state | Sealed Cubit state class |
| `setState` | Only for local UI-only state (obscureText, tab index) |
| Hardcoded width/height | Only for icons / design tokens, never for cards/carousels |
