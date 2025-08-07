# CRUSH.md - Nu Base Codebase Guidelines

## Build/Test Commands
- No explicit build system found (likely Nushell scripts)
- Test individual scripts with: `nu path/to/script.nu`
- Lint with: `nulib check path/to/script.nu`

## Code Style
- File naming: lowercase with `.nu` extension
- Indentation: 2 spaces
- Imports: Grouped at top of file
- Error handling: Use `try`/`catch` blocks
- Naming:
  - Variables: `snake_case`
  - Commands: `kebab-case`
  - Modules: `lowercase`

## Project Structure
- Modules in `modules/` directory
- Configs in `data/config/`
- Systemd services in `data/systemd/`

## Git
- Added `.crush` to `.gitignore`