<div align="center">

```
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║  ███████╗███████╗██████╗  ██████╗        ██████╗  █████╗ ██╗   ██╗    █████╗ ██╗  ║
║  ╚══███╔╝██╔════╝██╔══██╗██╔═══██╗       ██╔══██╗██╔══██╗╚██╗ ██╔╝   ██╔══██╗██║  ║
║    ███╔╝ █████╗  ██████╔╝██║   ██║ █████╗██║  ██║███████║ ╚████╔╝    ███████║██║  ║
║   ███╔╝  ██╔══╝  ██╔══██╗██║   ██║ ╚════╝██║  ██║██╔══██║  ╚██╔╝     ██╔══██║██║  ║
║  ███████╗███████╗██║  ██║╚██████╔╝       ██████╔╝██║  ██║   ██║   ██╗██║  ██║██║  ║
║  ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝        ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═╝╚═╝  ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
```

# Security R&D to production. Same day. Same safety.

**Gibson is the platform where new security capabilities become production-worthy on day one.**

[![Discord](https://img.shields.io/badge/Discord-Join_Community-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mkqd6mU3)
[![Email](https://img.shields.io/badge/Contact-anthony@zero--day.ai-red?style=for-the-badge&logo=gmail&logoColor=white)](mailto:anthony@zero-day.ai)

</div>

---

## The problem Gibson solves

Security moves at research speed. New tools, new techniques, new agents drop every week. Your team wants to run the thing they read about Monday morning in production by Friday.

Today, they can't:

- **Run it on a laptop.** Fast. Invisible to the SOC. Zero governance. Not production.
- **Wait for the platform team.** Six months per tool: isolation, IAM, audit, networking, secrets, findings pipeline, ticketing, observability. By the time it ships, the window has closed.
- **Buy a vendor product.** Expensive. Opinionated. Never exactly what your team needs.

**Gibson is the fourth option.** Wrap the tool. Deploy it. It's production-worthy on arrival — because the substrate already is.

---

## What "production-worthy on day one" actually means

When a new tool, agent, or plugin lands in Gibson, the substrate gives it:

- **Hardware-isolated execution.** Every invocation runs inside a microVM with a kernel boundary. Untrusted code, LLM-generated payloads, novel binaries — none of them can escape.
- **Scoped capabilities.** Every tool ships with a declared permission surface: which teams can invoke it, which data it can touch, which other tools or agents it can chain to. Checked on every single call.
- **Automatic knowledge-graph integration.** Output becomes typed nodes in a shared graph the rest of your fleet can query. No per-tool ingestion code.
- **Audit trail, tracing, observability.** Every call is logged, traced, metered. Flows to your SIEM. No separate wiring.
- **Deployable anywhere.** Your cluster, your customer's cluster, or inside your SaaS — same artifact.

Your team writes the interesting part. The substrate handles the rest.

---

## How the pieces fit

Four pillars. Each one is the mechanism that makes "production-worthy on day one" actually true.

| Pillar | What it gives your team |
|---|---|
| **Agent Development Kit** | Define your domain in YAML. The SDK generates proto types, Go types, validators, and graph query builders from one source of truth. Wrap a new tool in hours, not sprints. No ingestion code. No retrieval code. No drift. |
| **Setec microVM sandbox** | Every agent action — tool execution, LLM-generated code, file edit, network call — runs inside a Firecracker microVM with sub-100ms cold start. Hardware isolation by default, on every invocation. |
| **Capability-scoped RBAC** | Every agent, tool, and API key carries a capability scope. Checked on every harness call, not just at the API gateway. A compromised or prompt-injected agent cannot exceed its grants. |
| **Split-plane deployment** | Lightweight data plane in your cluster. Control plane hosted by Gibson — or fully on-prem at the enterprise tier. Credentials, raw artifacts, and LLM traffic never leave your perimeter. |

---

## Example: a new tool on Monday morning

An analyst reads about a new fuzzer at a conference on Monday. Tomorrow's target is hers by lunch.

**Without Gibson:** Platform request Monday. Security review week 3. IAM wiring week 6. Findings pipeline week 10. Prod in month 5. By then the tool is obsolete.

**With Gibson:**

```bash
# Monday 10am — wrap the tool
gibson tool scaffold fuzzer-xyz --binary ./fuzzer-xyz

# Monday 2pm — register and deploy
gibson tool register fuzzer-xyz
helm upgrade gibson --reuse-values

# Monday 3pm — scope it to the team that owns it
gibson rbac grant --team appsec --tool fuzzer-xyz

# Monday 4pm — it's running in prod
gibson mission run --tool fuzzer-xyz --target internal-api.corp
```

Every invocation runs in a microVM. Findings flow into the knowledge graph. RBAC gates who can call it. Audit events stream to your SIEM. OTel traces land in your observability stack.

**Same day. Same safety.**

---

## What your team builds on top

Gibson is purpose-built for security work. The agents, tools, and plugins your team would actually ship:

| Domain | Example |
|---|---|
| **Continuous pentest** | Autonomous recon + exploitation chains that adapt to the target |
| **Patch validation** | Apply a candidate patch in a sandbox, re-run the exploit, verify the fix |
| **Vulnerability verification** | Reproduce a CVE against your asset inventory, confirm blast radius |
| **Attack surface management** | Continuous discovery and change detection across internal and external surfaces |
| **LLM red-teaming** | Prompt injection, jailbreak, RAG poisoning, tool-abuse testing against your own AI systems |
| **Compliance evidence** | Automated control validation and evidence collection, auditor-ready |
| **Incident triage** | Log triage, IOC correlation, automated threat hunting |

---

## The SDK in two minutes

```go
type MyAgent struct{}

func (a *MyAgent) Execute(ctx context.Context, task agent.Task, h agent.Harness) (agent.Result, error) {
    // BYOK LLM, abstract slot — not model-locked
    resp, _ := h.Complete(ctx, "primary", []llm.Message{
        llm.NewSystemMessage("You are a security analyst"),
        llm.NewUserMessage(task.Goal),
    })

    // Run a tool. Inside a microVM. Scoped to this agent's capabilities.
    output, _ := h.ExecuteTool(ctx, "fuzzer-xyz", &pb.FuzzRequest{
        Target: "https://internal-api.corp/v1/login",
    })

    // Findings auto-flow to the knowledge graph.
    h.SubmitFinding(ctx, agent.Finding{
        Title:    "Authentication bypass via header injection",
        Severity: agent.SeverityHigh,
    })

    return agent.NewSuccessResult("done"), nil
}
```

Three tiers of memory come for free: working (ephemeral, per-mission), mission (persistent), long-term (cross-mission graph). Sub-agent delegation, plugin access, OTel tracing, Langfuse LLM observability — all on the harness.

---

## Knowledge graph as native memory

Every entity your agents and tools discover lands in a shared graph with typed relationships:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│   Mission ──[HAS_RUN]──▶ MissionRun ──[CONTAINS_AGENT_RUN]──▶ AgentRun     │
│                                                                             │
│   Host ──[HAS_PORT]──▶ Port ──[RUNS_SERVICE]──▶ Service ──[HAS_ENDPOINT]──▶ Endpoint │
│                                                                             │
│   Domain ──[HAS_SUBDOMAIN]──▶ Subdomain ──[RESOLVES_TO]──▶ Host            │
│                                                                             │
│   Finding ──[AFFECTS]──▶ {Host, Service, Endpoint}                          │
│   Finding ──[HAS_EVIDENCE]──▶ Evidence                                      │
│   Finding ──[USES_TECHNIQUE]──▶ Technique (MITRE ATT&CK / ATLAS)           │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

UUID identity with automatic deduplication. CEL validators on every node type. Taxonomy driven by one YAML file — edit it, regenerate, the SDK, graph schema, and query surface move together.

---

## Deployment

**Default tier.** Gibson hosts the control plane. You run lightweight agent, tool, and plugin workers in your cluster. Credentials, raw artifacts, and LLM calls (BYOK, direct to your provider) never leave your perimeter.

**Enterprise tier.** Full on-prem. Same Helm chart, everything deployed inside your cluster. For air-gap, ITAR, and regulated buyers who can't let anything leave.

**Embedded tier.** Deploy Gibson inside your own SaaS to power agent features for your customers.

Runs on EKS, GKE, AKS, k3s, OpenShift, and air-gapped clusters.

```yaml
# values.yaml — standard tier (data plane only)
gibson:
  mode: data-plane
  controlPlane:
    endpoint: https://control.zero-day.ai
  agents:
    network-recon:
      replicas: 3
  tools:
    fuzzer-xyz:
      workers: 5
      concurrency: 8
  sandbox:
    runtime: setec
    networkPolicy: deny-all
```

---

## Licensing

**Business Source License (BSL 1.1)** — converts to Apache 2.0 after 4 years. Same model as HashiCorp, Sentry, CockroachDB, MariaDB.

| Use case | Tier |
|---|---|
| Bug bounty hunting | Free (keep all rewards) |
| Internal security team | Commercial |
| MSSP / consulting | Commercial |
| Offering as a managed service | Commercial |

[Contact for pricing →](mailto:anthony@zero-day.ai)

---

## Tech stack

| Layer | Technology |
|---|---|
| Language | Go 1.21+ |
| RPC | gRPC + Protocol Buffers |
| Sandbox | Firecracker + Kata, via the Setec K8s operator |
| Authorization | OpenFGA (Zanzibar relation model) |
| Job queue | Redis Stack |
| Knowledge graph | Neo4j |
| Vector store | Qdrant (optional) |
| LLM providers | Anthropic, OpenAI, Google, Ollama — BYOK |
| Observability | Langfuse, OpenTelemetry, Prometheus, Loki |
| Deployment | Kubernetes, Helm |

---

<div align="center">

## Build the agents your CISO, SRE, and auditor all signed off on.

**[Schedule a demo](mailto:anthony@zero-day.ai?subject=Gibson%20Demo%20Request)** · **[Join Discord](https://discord.gg/mkqd6mU3)**

---

**Zero-Day.ai**

[anthony@zero-day.ai](mailto:anthony@zero-day.ai)

</div>
