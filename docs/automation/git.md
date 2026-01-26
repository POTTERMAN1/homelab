## Reversing Changes
In this project, we follow a **Non-Destructive Reversion** policy:

**Rule:** Use `git revert -m 1` for merged Pull Requests. Or `Revert` option from the Forgejo GUI on the website.

**Reasoning:** Maintains a clear audit trail and prevents history divergence for runners and collaborators.