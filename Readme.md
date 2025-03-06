## THIS README.MD IS TO EXPLAIN THE LIST OF COMMANDS AND ITS ORDER.
### GIT COMMITTING THE CHANGES TO THE REPO: PUBLIC-PRIVATE CONSORTIUM

### 1. After making changes, add them to staging:
```bash
git add .

git commit -m "Describe your changes here"

git push origin master

git status

git rebase


DOCKER COMMANDS


cd docker/app

docker compose up -d

docker compose build --no-cache

geth --dev