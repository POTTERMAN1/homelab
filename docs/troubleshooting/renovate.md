# Troubleshooting | Renovate

## Issue: Error 401, Token Unauthorized
**Symptom:** Renovate failed to fetch package updates from `github.com` and `ghcr.io`, resulting in `401 Unauthorized` warnings in the logs.

**Root Cause:** The GitHub Personal Access Token (PAT) used for metadata lookups had expired or lacked the `read:packages` scope.

**Resolution:**
1. Generated a new GitHub PAT (classic) with `repo` and `read:packages` scopes.\
2. Updated the `GITHUB_COM_TOKEN` secret in the Forgejo runner environment.\
3. Verified fix by re-running the Renovate CI pipeline.



## Issue: 'GITHUB' in the secret name
**Symptom:** Forgejo prevents using `GITHUB` in the name of the secrets.

**Resolution:** Stored the GitHub PAT as `RENOVATE_CHANGELOG` and mapped it to `RENOVATE_GITHUB_COM_TOKEN` within the Action's `env` block.



## Issue: actions/checkout@v6 fails with "got node24"
**Symptom:** Forgejo Action fails during the "Set up job" phase with an error stating `runs.using` must be one of `node12, node16, node20`, but got `node24`.

**Root Cause:** `actions/checkout@v6` requires a Node 24 runtime environment. The current Forgejo `act_runner` validation schema does not yet support Node 24.

**Resolution:** Downgraded to `actions/checkout@v4`, which utilizes the Node 20 runtime and is fully compatible with the current runner version. 