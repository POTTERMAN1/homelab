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