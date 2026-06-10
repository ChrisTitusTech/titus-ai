# Skills for AI Agents

## What is a Skill?

A skill is a reusable set of instructions, expertise, workflows, and best practices that can be applied across multiple projects.

Use skills for knowledge that is:

* Reused frequently
* Independent of a specific repository
* Domain-specific
* Too repetitive to place in every AGENTS.md

## Skills vs Project Files

| File       | Purpose                                     |
| ---------- | ------------------------------------------- |
| AGENTS.md  | How an agent should work in this repository |
| SPEC.md    | What the project should do                  |
| ROADMAP.md | Long-term project direction                 |
| TASKS.md   | Current actionable work                     |
| Skill      | Reusable expertise across many repositories |

## Recommended Structure

```text
~/.codex/skills/
├── homelab-admin/
├── forgejo-maintainer/
├── podman-operator/
├── linux-sysadmin/
├── rust-cli/
├── python-ai/
└── ai-project-manager/
```

## Example Skill Layout

```text
skill-name/
├── SKILL.md
├── examples/
└── templates/
```

## Best Practices

### Keep Skills Focused

Good:

* Podman Administration
* Forgejo Maintenance
* Rust CLI Development

Bad:

* Everything Linux
* Full Stack Engineering
* General Programming

### Keep Skills Small

Recommended:

* Under 100 lines
* Actionable guidance
* Clear workflows
* Common commands

Avoid:

* Large documentation dumps
* Extensive tutorials
* Complete manuals

### Put Project Knowledge Elsewhere

Do not place project requirements in skills.

Use:

* SPEC.md
* ROADMAP.md
* TASKS.md

for project-specific information.

## Suggested Skills

### homelab-admin

Expertise:

* Rocky Linux
* Systemd
* Networking
* NFS
* Synology
* DNS
* Reverse Proxies
* Storage Management

### podman-operator

Expertise:

* Podman
* Quadlet
* Rootless Containers
* Systemd Integration
* Container Networking
* Volume Management
* Production Deployment

### forgejo-maintainer

Expertise:

* Forgejo
* Gitea Migration
* Repository Administration
* SSH Configuration
* Actions Runners
* Backups
* Upgrades

### linux-sysadmin

Expertise:

* Rocky Linux
* Ubuntu
* SSH
* SELinux
* Permissions
* Firewalls
* Service Management

### rust-cli

Expertise:

* Cargo
* Clap
* Testing
* Documentation
* Release Workflows
* CLI Design

### python-ai

Expertise:

* UV
* Local LLMs
* OpenAI APIs
* OpenRouter
* Agent Frameworks
* AI Tooling

### ai-project-manager

Workflow:

1. Read AGENTS.md
2. Read SPEC.md
3. Read ROADMAP.md
4. Read TASKS.md
5. Generate implementation plan
6. Execute one phase at a time
7. Run validation
8. Update task status

## Personal Workflow

When starting a project:

1. Create AGENTS.md
2. Create SPEC.md
3. Create ROADMAP.md
4. Create TASKS.md
5. Attach relevant skills
6. Ask the agent for a plan
7. Execute incrementally
8. Review and commit often

## Rule of Thumb

Skills contain expertise.

Projects contain requirements.

Keep them separate.

