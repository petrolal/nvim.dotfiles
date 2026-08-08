---
baseline_commit: db64133972545c6bde97faf8e116ad091734bfca
---

# Story 38.5: Spring Boot & Quarkus Microservice Launcher Keymap

## Status: review

## Story Description
As a DevOps / JVM Engineer,  
I want `<leader>cjs` bound to launch Spring Boot or Quarkus applications via Maven wrapper or Gradle wrapper,  
So that microservices can be launched with a single key combination.

## Acceptance Criteria
- [x] **Given** a Maven or Gradle JVM project, **When** pressing `<leader>cjs`, **Then** `./mvnw spring-boot:run` / `./gradlew bootRun` / `./mvnw quarkus:dev` initiates in a terminal split.

## Tasks
- [x] Add `<leader>cjs` shortcut in `lua/cumulus/core/keymaps.lua` to trigger Spring Boot / Quarkus main app execution using `maven.lua` or `gradle.lua`.

## Dev Agent Record

### Implementation Plan
- Added `<leader>cjs` shortcut in `lua/cumulus/core/keymaps.lua` for `java`, `kotlin`, and `groovy` filetypes.
- Dynamically detects build tool (`pom.xml` vs `build.gradle` / `build.gradle.kts`) and framework (`quarkus` vs `spring-boot`), executing `./mvnw spring-boot:run`, `./gradlew bootRun`, `./mvnw quarkus:dev`, or `./gradlew quarkusDev` in a terminal split.

### Debug Log
- Verified headless Lazy plugin load (`nvim --headless "+Lazy check" +qa`) and executed `./scripts/validate.sh` - all 5 automated test suites passed cleanly.

### Completion Notes
- Completed Spring Boot & Quarkus microservice launcher keymap integration.

## File List
- `lua/cumulus/core/keymaps.lua`

## Change Log
- Add `<leader>cjs` keymap in `lua/cumulus/core/keymaps.lua`.
