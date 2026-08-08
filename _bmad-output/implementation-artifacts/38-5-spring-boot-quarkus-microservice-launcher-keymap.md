# Story 38.5: Spring Boot & Quarkus Microservice Launcher Keymap

## Status: ready-for-dev

## Story Description
As a DevOps / JVM Engineer,  
I want `<leader>cjs` bound to launch Spring Boot or Quarkus applications via Maven wrapper or Gradle wrapper,  
So that microservices can be launched with a single key combination.

## Acceptance Criteria
- [ ] **Given** a Maven or Gradle JVM project, **When** pressing `<leader>cjs`, **Then** `./mvnw spring-boot:run` / `./gradlew bootRun` / `./mvnw quarkus:dev` initiates in a terminal split.

## Tasks
- [ ] Add `<leader>cjs` shortcut in `lua/cumulus/core/keymaps.lua` to trigger Spring Boot / Quarkus main app execution using `maven.lua` or `gradle.lua`.
