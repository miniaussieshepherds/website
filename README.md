# website

## Deploy (commit + push)

### Option A: One command

- Run: `./deploy.ps1`
- It will stage all changes, ask for a commit message, commit, and push to `origin/main`.

You can also pass a message:

- `./deploy.ps1 -Message "Your message here"`

### Option B: VS Code task

- Run the task: **Deploy (commit + push)**