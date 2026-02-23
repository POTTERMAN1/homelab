# GitOps & CI/CD Pipelines

This infrastructure operates on strict **GitOps** principles. No changes are made manually via SSH or web interfaces. Every configuration change, documentation update, or service deployment must be committed to the central Git repository.

## The Forgejo Hub
The primary Git server is a self-hosted **Forgejo** instance. This acts as the single source of truth for the entire homelab. Forgejo's built-in Actions runner executes the CI/CD workflows.

## Staging & Linting Pipeline
To ensure high code quality and prevent broken configurations from reaching production, a CI pipeline runs automatically on the `staging` branch or when a Pull Request is opened against `main`. 

This pipeline runs strict `yamllint` and `ansible-lint` checks. It utilizes **Ansible Vault** to securely decrypt host variables on the ephemeral runner using injected repository secrets.

```yaml
--8<-- ".forgejo/workflows/lint_check.yml"
```

## GitHub Mirroring
To maintain an off-site backup and a public-facing portfolio, the main branch is continuously mirrored to GitHub. This workflow triggers automatically upon a successful merge to main.
```yaml
--8<-- ".forgejo/workflows/mirror.yml"
```

## Automated Documentation
When the mirror reaches GitHub, a final GitHub Action triggers the build and deployment of this exact MkDocs site to GitHub Pages, ensuring the documentation is never out of sync with the codebase.
```yaml
--8<-- ".github/workflows/deploy_docs.yml"
```
