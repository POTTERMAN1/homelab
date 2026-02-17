# Ansible & Vault Troubleshooting

### Issue: Vault Decryption Failed
**Symptom:** `Decryption failed (no vault secrets were found that could decrypt).`
**Root Cause:** Context mismatch. Ansible is ignoring the `ansible.cfg` file because the command was run from the wrong directory, so it doesn't know where the `.ansible_vault_pass` file is.
**Fix:** Always ensure you `cd` into the directory containing `ansible.cfg` (e.g., `cd ~/git/homelab/ansible`) before running `ansible-playbook` or `ansible-vault` commands.

### Issue: "_AnsibleTaggedStr" YAML Error
**Symptom:** `failed to combine variables, expected dicts but got a 'dict' and a '_AnsibleTaggedStr'`
**Root Cause:** The encrypted vault file contains a raw string instead of a valid YAML key-value pair.
**Fix:** Edit the vault (`ansible-vault edit vault.yml`) and ensure the secret is formatted with a variable name:
```yaml
# WRONG
"my_secret_password"
vault_my_secret= "my_secret_password"
# RIGHT
vault_my_secret: "my_secret_password"
```
### Issue: Playbook vault variable not getting passed correctly
**Symptom:** A rendered configuration file shows the literal string `{{ vault_secret }}` instead of the decrypted password.
**Root Cause:** In Ansible YAML, if a value starts with a Jinja2 bracket, the entire line must be wrapped in quotes, otherwise the YAML parser treats it as a raw string.
**Fix:** Wrap the content or template variable in double quotes:
```yaml
content: "API_TOKEN={{ vault_api_token }}"
```

## APT Update Failures (GPG Keys & Repositories)

**Symptom:** Running an Ansible playbook with `apt: update_cache=true` fails with repository errors on Proxmox (`pve`) or Debian nodes (`debian-docker`).

**Root Cause & Resolutions:**
1. **PVE - Expired GPG Keys (xcaddy/Cloudsmith):** The keyring for third-party repos expired.
   * *Fix:* Remove the old key and fetch the new one via Ansible `ansible.builtin.get_url` or manually re-import the Cloudsmith GPG key for `xcaddy`.
2. **PVE - Lingering Enterprise Lists & Duplicates:** Proxmox tries to check the enterprise repo (which requires a sub) and fails. 
   * *Fix:* Ensure the `pve-enterprise.list` is deleted and there are no duplicate `pve-no-subscription` lines in `/etc/apt/sources.list.d/`.
3. **Debian - Missing Fish Shell Key:** Release 4 of `fish` requires a new GPG key.
   * *Fix:* Add the specific OpenSUSE/Fish repository key to the keyring before running the apt update task.

## Ansible-Lint: Missing `pipefail` Warning

**Symptom:**
`ansible-lint` throws a warning when using the `|` (pipe) operator in `ansible.builtin.shell` tasks.

**Cause:**
By default, standard shells will return an `ok` exit code if the *last* command in a pipe succeeds, even if the first command failed. This can create false positives in Ansible.

**Resolution:**
Add `set -o pipefail` to the start of the shell script, and explicitly define the executable as bash:
```yaml
- name: Example piped command
  ansible.builtin.shell: |
    set -o pipefail
    cat /some/file | grep "target"
  args:
    executable: /bin/bash