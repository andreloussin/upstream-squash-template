# Upstream Squash Template

A Docker-first project template with GitHub Actions to sync upstream changes as squash commits, while keeping your repository clean, independent, and easy to maintain.

## Purpose

This template is meant to be a reusable starting point for projects that will be deployed with Docker and possibly later with Kubernetes.

It also provides a clean way to import changes from an upstream repository without turning this repository into a classic fork. Instead of preserving the full upstream history, updates are brought in as squashed changes.

## Why this exists

- Start new projects with a Docker-ready base
- Keep the repository independent from upstream history
- Import upstream code changes as squashed commits
- Avoid merge noise and long upstream commit chains
- Make the repository easy to reuse as a template

## How the sync model works

The repository stores the last synced upstream commit SHA in a state file.  
When the workflow runs, it:

1. reads the previously synced SHA
2. fetches the latest upstream branch
3. compares the current upstream SHA with the last synced SHA
4. creates a temporary sync branch from the local base branch
5. applies upstream changes with `git merge --squash`
6. updates the sync state file
7. opens or updates a pull request

This keeps upstream changes visible in your repository while avoiding full upstream history.

## Repository variables

Configure these in **Settings → Secrets and variables → Actions → Variables**:

| Variable | Required | Default | Description |
|---|---:|---|---|
| `UPSTREAM_REPO` | Yes | None | Upstream repository in `owner/repo` format |
| `UPSTREAM_BRANCH` | No | `main` | Branch to sync from upstream |
| `BASE_BRANCH` | No | `main` | Local branch used as the PR base |
| `SYNC_BRANCH` | No | `sync-upstream-updates` | Temporary branch created by the workflow |
| `SYNC_STATE_FILE` | No | `.github/upstream-sync.sha` | File used to store the last synced upstream SHA |

## Workflow inputs

The workflow also supports manual overrides through `workflow_dispatch`.

The optional `upstream_branch` input is useful when you want to run a one-off sync from another branch without changing the repository variables. In normal usage, you can leave it empty and the workflow will use the configured variable or its default value.

## Template structure

```text
.
├── .github/
│   ├── workflows/
│   │   └── sync-upstream.yml
│   └── scripts/
│       └── generate-sync-pr-body.sh
├── docker/
│   ├── dev/
│   │   ├── Dockerfile
│   │   └── docker-compose.yml
│   ├── staging/
│   │   ├── Dockerfile
│   │   └── docker-compose.yml
│   └── prod/
│       ├── Dockerfile
│       └── docker-compose.yml
├── src/
├── tests/
├── .dockerignore
├── .env.example
├── LICENSE
├── Makefile
└── README.md
```


## Preparing the repository

Before enabling the workflow, make sure the repository is ready for it:

- GitHub Actions must be enabled
- The repository must allow workflows to create branches and pull requests
- The sync branch must not be protected if the workflow needs to force-push it
- The base branch name in the workflow must match your repository default branch
- The sync state file must exist or be created by the workflow
- The repository should include a .dockerignore file early in the project
- The Docker files should match the language or stack used by the project

## Docker files

This template ships with separate Docker environments for development, staging, and production.

### Development

The development environment is designed for local iteration and debugging.

Typical characteristics:

* bind-mounted source code
* interactive shell support
* hot reload support depending on the stack
* developer tooling available inside the container

Files:

* `docker/dev/Dockerfile`
* `docker/dev/docker-compose.yml`

### Staging

The staging environment is intended to simulate production more closely while still remaining suitable for testing and validation.

Typical characteristics:

* closer runtime parity with production
* reduced development tooling
* reproducible builds
* environment-specific configuration

Files:

* `docker/staging/Dockerfile`
* `docker/staging/docker-compose.yml`

### Production

The production environment is intended for deployment and runtime stability.

Typical characteristics:

* minimal runtime dependencies
* non-root container user
* optimized image size
* production-oriented configuration

Files:

* `docker/prod/Dockerfile`
* `docker/prod/docker-compose.yml`

### Build context

The Docker Compose files use the repository root as the build context so the containers can access the entire project while keeping Docker-related files organized under the `docker/` directory.

### Makefile integration

The repository also includes a `Makefile` to simplify common commands.

Typical usage:

```bash
make dev
make dev-build
make staging
make prod
```

### Notes

The provided Docker files are intentionally generic and should be adapted to the language, framework, and runtime requirements of your project.

## Typical use cases

- backend services
- APIs
- internal tools
- automation projects
- monorepos
- containerized applications
- projects that will later be deployed on Kubernetes

## License

This project is licensed under the MIT License.

You are free to use, modify, distribute, and adapt this template for personal or commercial projects.

See the `LICENSE` file for details.

## Contributing

Issues and pull requests are welcome.