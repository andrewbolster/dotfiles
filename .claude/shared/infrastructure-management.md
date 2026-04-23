# Infrastructure Management

This document covers operational management of key infrastructure services. Currently focused on LLM Gateways.

## LLM Gateways

### Overview

Two active gateway environments powered by **LiteLLM Enterprise**:

| Environment | URL | Purpose | SLA | Auth |
|-------------|-----|---------|-----|------|
| **llm.labs** | `llm.labs.blackduck.com` | R&D / self-service | Zero SLA | Okta SSO (self-service) |
| **llm.core** | `llm.core.blackduck.com` | Dev Enablement / Production | 3-9s | Manual onboarding |
| **nprd** | (staging) | Pre-prod staging | — | Rarely used |

**Architecture**: Clients → LiteLLM Proxy → PostgreSQL/Redis → Providers (Azure OpenAI multi-region, AWS Bedrock, Google Vertex AI)

**Telemetry**: Custom callbacks write to `self_service_telemetry_bronze.llm_gateway_telemetry.llm_gateway_usage` in Databricks.

**Infrastructure**: `llm.labs` runs in the Innovation Zone (IZ) Kubernetes cluster, VPN required. Helm charts at `charts/labs-service/` in `service-llm`.

### Confluence Documentation

Reference these pages rather than duplicating content here:

- **Main Gateway Page**: [LLM Gateway](https://blackduck.atlassian.net/wiki/spaces/DS/pages/255296765/LLM+Gateway) — usage instructions, model availability (~356 models), self-service onboarding, budget uplift process, team usage model
- **Troubleshooting Runbook**: [Troubleshooting LLM Operations](https://blackduck.atlassian.net/wiki/spaces/DS/pages/2181333054/Troubleshooting+LLM+Operations) — ExceededBudget errors, model access errors, key/model mismatches, token rate limits (Bedrock: 200 RPM), prompt-too-long, anthropic-beta header issues, VPN/ZPA timeouts, Zscaler blocks, 50x errors
- **Model Governance Framework**: [LLM Gateway Model Governance Framework](https://blackduck.atlassian.net/wiki/spaces/DS/pages/2389836234/LLM+Gateway+Model+Governance+Framework) — two-tier governance: Internal tier (DS authority, 3-day SLA) vs Product tier (multi-stakeholder, 14-day SLA)
- **2026-03 Cleanup AAR**: [2026-03 LLM Gateway Cleanup](https://blackduck.atlassian.net/wiki/spaces/DS/pages/2830369043/2026-03+LLM+Gateway+Cleanup) — after-action report for wildcard model cleanup (removed `bedrock/*`, `vertex_ai/*` wildcards)

### Management Repository

**Repo**: `/Users/bolster/src/service-llm/`

All management operations go through this repo. The repo has its own Claude agents; when working in that directory, those agents auto-load.

#### Initial Setup

Copy and populate `manage.ini` from the example:

```ini
[labs]
base_url = https://llm.labs.blackduck.com
api_key = sk-your-labs-master-key-here

[core]
base_url = https://llm.core.blackduck.com
api_key = sk-your-core-master-key-here

[DEFAULT]
default_environment = labs
```

Retrieve actual keys with `make secrets` (pulls from GitHub with `LABS_` prefix into `litellm.env`).

#### Management CLI

All operations use `./scripts/manage.py --env labs|core <command>`.

**Shortcut via Makefile** (prompts for environment interactively):

```bash
make add-users          # Interactive user addition
make list-users         # User list with budgets
make list-models        # Available models with costs
make budget-tracker     # Budget consumption tracking
make budget-analysis    # Budget analysis report
make find-missing-users # Users in form but not in gateway
make list-aliases       # Model aliases
make update-models      # Sync model config
make smoke              # Smoke test gateway connectivity
```

**Direct CLI** (specify env explicitly):

```bash
./scripts/manage.py --env labs list-users
./scripts/manage.py --env core dump-failure-logs --lookback 7
./scripts/manage.py --env labs add-users user@blackduck.com
./scripts/manage.py --env core list-models
```

#### Specialized Claude Agents in service-llm

When working in `/Users/bolster/src/service-llm/`, these agents are available:

- **log-analysis**: Analyze failure logs and error patterns
- **user-management**: Handle user onboarding, budget management
- **model-management**: Model inventory, alias management, governance
- **usage-analysis**: Telemetry queries, cost analysis, consumption reports

### Common Operational Activities

Based on observed patterns from Teams activity and support requests, ranked by frequency:

#### 1. Budget Bump Requests (Most Common)

Users hit the default $100/month budget and request increases.

- Default budget: $100/month per user
- Standard increment: $100 at a time
- Check current usage first before bumping

```bash
cd ~/src/service-llm
./scripts/manage.py --env labs list-users  # Check current budget/usage
./scripts/manage.py --env labs update-budget user@blackduck.com --budget 200
```

See Confluence troubleshooting page for ExceededBudget error context.

#### 2. User Onboarding

New users fill in the onboarding form but may not appear in the gateway.

- **llm.labs**: Okta SSO self-service — users should be able to onboard themselves
- **llm.core**: Manual — requires explicit addition via CLI
- `find-missing-users` identifies form submitters not yet in the gateway

```bash
make find-missing-users   # Find users who submitted form but aren't added
make add-users            # Interactive addition
```

#### 3. Model Access / Key-Model Mismatch Errors

Users report 4xx errors when accessing specific models. Common causes:
- Model was removed or renamed (especially post-wildcard cleanup)
- User's key was provisioned before a model was added
- Bedrock 200 RPM rate limit hit

Check the troubleshooting runbook for diagnosis steps.

```bash
make list-models          # Current model inventory
make list-aliases         # Model aliases (old names → new names)
./scripts/manage.py --env labs dump-failure-logs --lookback 7
```

#### 4. Hackathon / Team Bulk Setup

Recurring seasonal need for bulk user provisioning for events.

- Collect email list from event organiser
- Use `make add-users` with batch input
- Consider setting a group budget or per-user uplift

#### 5. 50x Infrastructure Errors

Transient errors from the IZ Kubernetes cluster for `llm.labs`. Usually self-resolving.

- Check if it's widespread (multiple users) vs single-user issue
- `make smoke` to test gateway connectivity
- Escalate to IZ cluster team if persistent

#### 6. Telemetry / Usage Reporting

Ad-hoc queries about who's using what and how much it costs.

```python
# Databricks table
self_service_telemetry_bronze.llm_gateway_telemetry.llm_gateway_usage
```

Use the `usage-analysis` agent or the `budget-analysis` Makefile target.

### Environment Differences

| Concern | llm.labs | llm.core |
|---------|----------|----------|
| Primary constraint | Budget (per-user $100/mo) | Rate limits |
| Onboarding | Self-service Okta SSO | Manual CLI |
| Reliability | Zero SLA, IZ cluster | 3-9s SLA |
| Network | VPN required | VPN required |
| Use case | Experimentation, R&D | Production tooling |

### Key Scripts

| Script | Purpose |
|--------|---------|
| `scripts/manage.py` | Main management CLI |
| `scripts/generate_litellm_config.py` | Generate/update LiteLLM config |
| `scripts/analyze_logs.py` | Log analysis helper |
| `scripts/check_keys.sh` | Validate API key health |
| `scripts/ModelInventory.ipynb` | Model inventory notebook |
