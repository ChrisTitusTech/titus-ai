# OpenAI model and API migrations

Verified against the [GPT-6 migration guide](https://developers.openai.com/api/docs/guides/latest-model)
on 2026-10-06. Recheck current official model and API documentation before
implementation; this reference is a routing aid, not a permanent API contract.

- Preserve an explicitly requested model and effective reasoning effort where
  supported. GPT-6 Astra and GPT-6.1 Sol do not support `none` or `minimal`;
  start with `low` when migrating from those levels and evaluate the result.
- Use Responses for Astra and GPT-6.1 Sol tool calling. Their Chat Completions
  support does not include tools. GPT-6 Sol and Luna allow Chat Completions
  function calling only at `reasoning_effort: "none"`.
- With reasoning enabled, remove unsupported `temperature`, `top_p`, and
  `top_logprobs`. Remove Chat Completions `logprobs` and the Responses
  `message.output_text.logprobs` include value. Check the exact model's schema.
- For migrations from GPT-5.5 or earlier, check the replacement of
  `prompt_cache_retention` with `prompt_cache_options.ttl: "30m"` and the
  model-specific cache boundaries and cache-write billing. See
  [prompt caching](https://developers.openai.com/api/docs/guides/prompt-caching).
- When changing effort within a conversation, check whether
  `configuration_update` input items are supported by the request mode before
  adopting them. They can preserve the cached prompt prefix; see
  [reasoning configuration](https://developers.openai.com/api/docs/guides/reasoning#change-reasoning-mid-conversation).
- Async tools and mid-turn steering require application lifecycle support.
  Adopt them only when requested behavior benefits: preserve call IDs and
  pending tool results according to the [async tool](https://developers.openai.com/api/docs/guides/async-tool-calling)
  and [steering](https://developers.openai.com/api/docs/guides/steering) guides.

Validate request construction and response parsing without live calls first.
Use authorized representative evaluations to compare quality, latency, and
actual cost. API prices and cache-write charges do not define Codex subscription
usage or purchased-credit billing.
