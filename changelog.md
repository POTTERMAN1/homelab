# Changelog - Homelab Project















## [0.1.0] - 2026-01-28 - GitOps Foundation & Workspace Optimization
### Added
- Feat: Initialized Ansible inventory.yaml with 4 hosts.
- Docs: Added `cachyos.md` to Troubleshooting section to add resolutions for host problems.
- Feat: New tasks regarding Kubernetes, S3, IaC and AWS setups added to Phase 2 roadmap.
- Feat: Added `content.code.annotate` to `mkdocs.yml` for future use.

### Fixed
- Issue: CachyOS hangs for 90 seconds during shutdown sequence.
- Issue: Asymmetric Routing / Gateway Conflict (ZeroTier)

### Changed
- Chore: Refactored Zellij layout to use SSH aliases for better portability across different workstation hosts.
- Chore: Refactored starship theme to use in Alacritty.
- Chore: Fixed formatting of `forgejo.md` and `hardware.md`.

### Security/Maintenance
- Chore: Forgejo labels for easier Issue organization.
- Chore: Forgejo Milestones.
- Feat: Releases in the "Release" section of the repository.
- Performed ZFS pool integrity check; `zpool status` confirmed 0 errors on primary storage.
- Audit: Performed security check using `git log -p | grep -Ei "password|token|secret|api_key"` to find any possible leaks in the `homelab` and `docker-compose` repos. None found.
- Docs: Added `hardware.md` to Troubleshooting. Hardware related Issues and Fixes.
- Docs: Added Issue: 27.3k write errors when `zpool status` was invoked on the PVE. `hardware.md`
- Docs: Added `cachyos.md` and `network.md` to the Troubleshooting documentation.
- Docs: Issue: CachyOS hangs for 90 seconds during shutdown sequence.
- Docs: Issue: Asymmetric Routing / Gateway Conflict (ZeroTier)


## [0.0.2] - 2026-01-28 - Documentation, Workstation and ZFS woes
### Added
- Feat: Zellij Dashboard layout with PVE/Docker/OMV/Ansible/CachyOS tabs. 
- Feat: Phase 1-6 Roadmap initialization. `./ROADMAP.md`
- Docs: Initial Network Graph via /infrastructure/network.md using Mermaid.js
- Feat: `CHANGELOG.md` is now functional
- Docs: Updated `renovate.md` and `forgejo.md` with the recent issues and fixes.

### Fixed
- Issue: Forgejo SSH authentication (Port 2222 vs 22 conflict).
- Issue: Repository sync warnings via Admin Operations.

### Security/Maintenance
- Critical/Fixed: 27.3k write errors when `zpool status` was invoked on the PVE.

## [0.0.1] - 2026-01-25 - The Foundation

### Added
- Feat: Initialized Project Homelab.
- Docs: Initialized MkDocs to serve as a documentation for the Project.
- Docs: Added initial set of rules in Git documentation.
- Docs: Added `/troubleshooting/forgejo.md` for documenting Issues and Fixes
- Docs: Added `/troubleshooting/renovate.md` for documenting Issues and Fixes

### Fixed
- Issue: Error 401, Token Unauthorized
- Issue: actions/checkout@v6 fails with "got node24"
- Issue: 'GITHUB' in the secret name