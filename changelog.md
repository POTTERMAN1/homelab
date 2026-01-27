# Changelog - Homelab Project

## [Unreleased - 0.0.2]
### Added
- Zellij Dashboard layout with PVE/Docker/OMV tabs.
- Phase 1-6 Roadmap initialization. ./ROADMAP.md
- Docs: Initial Network Graph via /infrastructure/network.md using Mermaid.js
- CHANGELOG.md is now functional
- Docs: Updated renovate.md and forgejo.md with the recent issues and fixes.

### Fixed
- Forgejo SSH authentication (Port 2222 vs 22 conflict).
- Repository sync warnings via Admin Operations.

## [0.0.1] - 2026-01-25 - The Foundation

### Added
- Initialized Project Homelab.
- Initialized MkDocs to serve as a documentation for the Project.
- Added initial set of rules in Git documentation.
- Docs: Added /troubleshooting/forgejo.md for documenting Issues and Fixes
- Docs: Added /troubleshooting/renovate.md for documenting Issues and Fixes

### Fixed
- Issue: Error 401, Token Unauthorized
- Issue: actions/checkout@v6 fails with "got node24"
- Issue: 'GITHUB' in the secret name