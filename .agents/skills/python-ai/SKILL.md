---
name: python-ai
description: Build and troubleshoot Python AI applications involving model APIs, local LLMs, retrieval, tools, agents, prompts, evaluation, or AI dependencies.
---

# python-ai

## Workflow

1. Inspect the affected provider, model, dependencies, prompts, tools, and data
   flow. Use the project's existing environment and test commands.
2. Determine privacy, latency, cost, and reliability impact.
3. Preserve existing rollback paths. Add feature flags or provider fallbacks
   only when requirements justify their complexity.
4. Implement the smallest model, prompt, retrieval, or tool change.
5. Validate deterministic code paths and representative AI behavior.

## Diagnostics

```bash
uv run python --version
uv pip list
uv run pytest
uv run ruff check .
uv run mypy .
```

These `uv` commands are examples for projects using `uv`. Check required
environment variables by presence only; never print their values or dump the
environment. Inspect only needed model configuration fields, excluding secrets.

## Safety Rules

- Never commit API keys, provider tokens, prompts containing secrets, or private data fixtures.
- Never rely on live model calls for ordinary unit tests.
- Use structured outputs when downstream code depends on response shape.
- Keep tools narrow, deterministic, and logged without secrets.
- Confirm current OpenAI API details from official docs when behavior may have changed.
- Preserve the requested model. Evaluate effort, retries, context size, and
  output length on representative tasks before claiming a cost improvement;
  API token prices do not establish Codex subscription credit usage.

## Validation

- Prompt assembly tests pass.
- Tool schema and parser tests pass.
- Retrieval filters return expected fixtures.
- Optional live-provider smoke tests are gated by environment variables.
- Logs expose model, tool, retry, and error decisions without secrets.
