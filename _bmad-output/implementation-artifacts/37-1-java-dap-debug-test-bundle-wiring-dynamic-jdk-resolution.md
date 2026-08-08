---
baseline_commit: db64133972545c6bde97faf8e116ad091734bfca
---

# Story 37.1: Java DAP Debug & Test Bundle Wiring & Dynamic JDK Resolution

## Status: review

## Story Description
As a Java Developer,  
I want `java-debug-adapter` and `vscode-java-test` jar bundles loaded in `ftplugin/java.lua` and dynamic JDK 21 path resolution in `lsp-java.lua`,  
So that step-debugging, unit testing, and SDKMAN JDK setups work out-of-the-box for Java.

## Acceptance Criteria
- [x] **Given** a Java buffer opened in Neovim, **When** JDTLS attaches, **Then** `init_options.bundles` loads `java-debug-adapter` and `vscode-java-test` jars from Mason, and `jdtls.setup_dap()` initializes debugging and test runner support.
- [x] **Given** Java 21 installed via SDKMAN, OpenJDK, or standard Linux paths, **When** loading `lsp-java.lua`, **Then** `java21_path` is dynamically resolved rather than hardcoded.

## Tasks
- [x] Update `ftplugin/java.lua` to scan Mason installation directories for `java-debug-adapter` (`com.microsoft.java.debug.plugin-*.jar`) and `vscode-java-test` (`*.jar`) bundles.
- [x] Pass `bundles` in `init_options` to `jdtls.start_or_attach(config)`.
- [x] Add `on_attach` callback in `ftplugin/java.lua` calling `require("jdtls").setup_dap({ hotcodereplace = "auto" })` and `require("jdtls.dap").setup_dap_main_class_configs()`.
- [x] Update `lua/cumulus/plugins/lsp-java.lua` to replace hardcoded `/usr/lib/jvm/java-21-openjdk-amd64` with a dynamic `find_java21_home()` helper that checks SDKMAN, OpenJDK, and default JVM paths.

## Dev Agent Record

### Implementation Plan
- Scanned Mason package paths for `java-debug-adapter` and `vscode-java-test` jar files inside `ftplugin/java.lua` and populated `init_options.bundles`.
- Added `on_attach` function in `ftplugin/java.lua` to initialize DAP via `jdtls.setup_dap()` and `jdtls.dap.setup_dap_main_class_configs()`.
- Replaced static Java 21 path in `lua/cumulus/plugins/lsp-java.lua` with dynamic glob searching for system OpenJDKs and SDKMAN installations.

### Debug Log
- Verified headless Lazy plugin load (`nvim --headless "+Lazy check" +qa`) and executed `./scripts/validate.sh` - all 5 validation suites passed cleanly.

### Completion Notes
- Completed DAP debug adapter and test bundle wiring in `ftplugin/java.lua`.
- Completed dynamic Java 21 path resolution in `lsp-java.lua`.

## File List
- `ftplugin/java.lua`
- `lua/cumulus/plugins/lsp-java.lua`

## Change Log
- Add Mason `java-debug-adapter` and `vscode-java-test` bundle discovery and DAP setup in `ftplugin/java.lua`.
- Replace hardcoded `/usr/lib/jvm/java-21-openjdk-amd64` path with dynamic `find_java21_home()` in `lua/cumulus/plugins/lsp-java.lua`.
