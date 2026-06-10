---
name: python-ai
description: Build and troubleshoot Python AI applications with uv, local LLMs, OpenAI APIs, OpenRouter, agent frameworks, retrieval, tool calling, evaluation, and AI developer tooling. Use when Codex is asked to implement Python AI features, manage AI dependencies, design prompts or agents, debug model calls, or prepare AI app validation.
---

# python-ai

## Workflow

1. Gather provider, model, dependency, prompt, tool, and data-flow context.
2. Determine privacy, latency, cost, and reliability impact.
3. Create rollback with feature flags, fixtures, and provider fallbacks.
4. Implement the smallest model, prompt, retrieval, or tool change.
5. Validate deterministic code paths and representative AI behavior.

## Diagnostics

```bash
uv run python --version
uv pip list
uv run pytest
uv run ruff check .
uv run mypy .
env | grep -E 'OPENAI|OPENROUTER|MODEL'
```

## Safety Rules

- Never commit API keys, provider tokens, prompts containing secrets, or private data fixtures.
- Never rely on live model calls for ordinary unit tests.
- Use structured outputs when downstream code depends on response shape.
- Keep tools narrow, deterministic, and logged without secrets.
- Confirm current OpenAI API details from official docs when behavior may have changed.

## Validation

- Prompt assembly tests pass.
- Tool schema and parser tests pass.
- Retrieval filters return expected fixtures.
- Optional live-provider smoke tests are gated by environment variables.
- Logs expose model, tool, retry, and error decisions without secrets.
