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

### Kubernetes-Native Agent Development Kit

**Build, deploy, and orchestrate autonomous AI agents on your infrastructure.**

[![Discord](https://img.shields.io/badge/Discord-Join_Community-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mkqd6mU3)
[![Email](https://img.shields.io/badge/Contact-anthony@zero--day.ai-red?style=for-the-badge&logo=gmail&logoColor=white)](mailto:anthony@zero-day.ai)

</div>

---

## What We Build

**Gibson** is a Kubernetes-native framework for building and running autonomous AI agents. You bring the agents—Gibson handles orchestration, state management, tool execution, observability, and persistent knowledge.

Think of it as **Kubernetes for AI agents**: you define what your agents do, Gibson handles everything else.

---

## The Stack

| Component | What It Is |
|-----------|------------|
| **Gibson Framework** | DAG-based mission orchestrator, agent runtime, distributed tool execution |
| **Gibson SDK** | Go SDK for building agents, tools, and plugins with type-safe APIs |
| **GraphRAG** | Neo4j-backed knowledge graph that persists across missions |

```
┌─────────────────────────────────────────────────────────────────────┐
│                         YOUR K8s CLUSTER                            │
│                                                                     │
│   CLI ──▶ Daemon (gRPC) ──▶ Orchestrator ──▶ Agents ──▶ Tools      │
│                │                  │              │                  │
│                ▼                  ▼              ▼                  │
│             [etcd]            [Redis]        [Neo4j]               │
│            registry         tool queues     GraphRAG               │
└─────────────────────────────────────────────────────────────────────┘
```

Agents reason with frontier LLMs (Claude, GPT, Gemini, Ollama). Tools execute via Redis-backed work queues. Everything gets stored in Neo4j for cross-mission intelligence.

---

## Why Kubernetes-Native?

Gibson deploys as workloads on YOUR cluster. This is a fundamental architectural choice:

- **Internal network access** - Agents operate where external scanners can't reach
- **Air-gapped environments** - Data never leaves your network boundary
- **CI/CD integration** - Missions are YAML; deploy agents like any other workload
- **Compliance requirements** - ITAR, HIPAA, NYDFS—data residency built in
- **Horizontal scaling** - Scale tool workers independently via replicas
- **GitOps workflows** - Agents, missions, and configs are all declarative

---

## The SDK

Build production agents in Go with the Gibson SDK. Every agent gets:

| Capability | What It Provides |
|------------|------------------|
| **LLM Slots** | Abstract LLM requirements (tool use, vision, JSON mode) resolved at runtime |
| **Tool Execution** | Redis-backed work queues with Protocol Buffer I/O |
| **Three-Tier Memory** | Working (ephemeral) → Mission (Redis) → Long-term (vector) |
| **GraphRAG** | Neo4j knowledge graph with automatic entity persistence |
| **Sub-Agent Delegation** | Agents can spawn and coordinate other agents |
| **OpenTelemetry** | Distributed tracing across daemon, agents, and tools |
| **Langfuse** | LLM observability—token usage, cost tracking, turn analysis |

### Component Types

| Type | Purpose | State | I/O Format | Example |
|------|---------|-------|------------|---------|
| **Agent** | Autonomous LLM-driven operations | Stateful | Harness API | network-recon, api-discovery |
| **Tool** | Atomic operations (wrappers around utilities) | Stateless | Protocol Buffers | nmap, httpx, nuclei |
| **Plugin** | External service integrations | Stateful | JSON | shodan, gitlab, scope-ingestion |

### Quick Example

```go
type MyAgent struct{}

func (a *MyAgent) Execute(ctx context.Context, task agent.Task, h agent.Harness) (agent.Result, error) {
    // Use LLM with abstract slot
    resp, _ := h.Complete(ctx, "primary", []llm.Message{
        llm.NewSystemMessage("You are a security analyst"),
        llm.NewUserMessage(task.Goal),
    })

    // Execute tools via Redis queue (proto I/O)
    output, _ := h.ExecuteTool(ctx, "nmap", &pb.ScanRequest{Target: "192.168.1.0/24"})

    // Persist to GraphRAG automatically
    host := graphrag.NewHost()
    host.Ip = "192.168.1.100"

    // Submit findings
    h.SubmitFinding(ctx, agent.Finding{
        Title:    "Open Admin Panel",
        Severity: agent.SeverityHigh,
    })

    return agent.NewSuccessResult("Complete"), nil
}
```

---

## GraphRAG Knowledge System

Every entity discovered by agents persists in Neo4j with full relationship mapping:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           GRAPHRAG SCHEMA                                   │
│                                                                             │
│   Mission ──[HAS_RUN]──▶ MissionRun ──[CONTAINS_AGENT_RUN]──▶ AgentRun     │
│                                                                             │
│   Host ──[HAS_PORT]──▶ Port ──[RUNS_SERVICE]──▶ Service ──[HAS_ENDPOINT]──▶ Endpoint │
│                                                                             │
│   Domain ──[HAS_SUBDOMAIN]──▶ Subdomain ──[RESOLVES_TO]──▶ Host            │
│                                                                             │
│   Finding ──[AFFECTS]──▶ {Host, Service, Endpoint}                          │
│   Finding ──[HAS_EVIDENCE]──▶ Evidence                                      │
│   Finding ──[USES_TECHNIQUE]──▶ Technique (MITRE ATT&CK/ATLAS)             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Features:**
- UUID-based entity identity with automatic deduplication
- CEL-based validation rules on all entity types
- YAML-driven taxonomy (single source of truth for all generated code)
- Tool outputs auto-populate via `DiscoveryResult` proto field
- Cross-mission intelligence—agents learn from past engagements

---

## Use Cases

The framework is domain-agnostic. Security is our focus, but Gibson can orchestrate any autonomous operation:

| Domain | What Gibson Does |
|--------|------------------|
| **Security Testing** | Autonomous pentesting with tool chaining and adaptive reasoning |
| **Compliance** | Evidence collection, control validation, audit trail generation |
| **Attack Surface Management** | Continuous asset discovery and change detection |
| **LLM Red-Teaming** | Prompt injection, jailbreak testing, RAG poisoning |
| **Infrastructure Assessment** | K8s cluster audits, drift monitoring, misconfiguration detection |
| **Incident Response** | Log triage, automated threat hunting, IOC correlation |

---

## Tool Execution System

Tools run as stateless workers consuming from Redis queues:

```
┌─────────────────────────────────────────────────────────────────┐
│                          TOOL WORKERS                            │
│                                                                  │
│   Agent ──▶ LPUSH tool:nmap:queue ──▶ [ Worker Pool ]           │
│                                              │                   │
│                                              ▼                   │
│                                    PUBLISH results:<jobID>       │
│                                              │                   │
│   Agent ◀── SUBSCRIBE results:<jobID> ◀─────┘                   │
└─────────────────────────────────────────────────────────────────┘
```

**Key patterns:**
- Protocol Buffer I/O with auto-generated types
- `DiscoveryResult` field (proto field 100) auto-populates GraphRAG
- Horizontal scaling via K8s replica count
- Health checks, heartbeats, graceful shutdown
- Concurrency tuning per tool type

---

## Observability

Built-in observability across the entire stack:

| System | What It Tracks |
|--------|----------------|
| **Langfuse** | LLM calls, token usage, cost per mission/agent, turn analysis |
| **OpenTelemetry** | Distributed traces across daemon → agents → tools |
| **Structured Logging** | JSON logs with trace ID correlation |
| **Redis Insights** | Queue depth, worker count, job latency |

---

## Deployment

```yaml
# Helm values.yaml
gibson:
  daemon:
    replicas: 2
  redis:
    persistence: true
  neo4j:
    edition: enterprise
  agents:
    network-recon:
      replicas: 3
    api-discovery:
      replicas: 2
  tools:
    nmap:
      workers: 5
      concurrency: 8
    httpx:
      workers: 3
      concurrency: 4
```

Supports: **EKS** • **GKE** • **AKS** • **k3s** • **OpenShift** • **Air-gapped**

---

## For Security Teams

Gibson is free for bug bounty research. Enterprise/consulting use requires a commercial license.

| Use Case | License |
|----------|---------|
| **Bug bounty hunting** | Free (keep all rewards) |
| **Internal security testing** | Commercial |
| **Consulting/MSSP** | Commercial |
| **Offering as a service** | Commercial |

**[Contact for enterprise pricing →](mailto:anthony@zero-day.ai)**

---

## Get Started

```bash
# Install CLI
go install github.com/zero-day-ai/gibson/cmd/gibson@latest

# Initialize local environment
gibson init

# Run a mission
gibson mission run -f mission.yaml

# Scaffold a new agent
gibson agent scaffold my-agent

# Deploy to K8s
helm install gibson zero-day-ai/gibson -f values.yaml
```

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Language** | Go 1.21+ |
| **RPC** | gRPC + Protocol Buffers |
| **Service Registry** | etcd |
| **Job Queue** | Redis Stack (RediSearch FTS) |
| **Knowledge Graph** | Neo4j 5.x |
| **Vector Store** | Qdrant (optional) |
| **LLM Providers** | Anthropic, OpenAI, Google, Ollama |
| **Observability** | Langfuse, OpenTelemetry |
| **Deployment** | Kubernetes, Helm |

---

## License

**Business Source License (BSL 1.1)** — same as MariaDB, HashiCorp, Sentry, CockroachDB.

Converts to Apache 2.0 after 4 years.

---

<div align="center">

## Contact

**Building autonomous agents for your infrastructure? Let's talk.**

[![Schedule a Demo](https://img.shields.io/badge/Schedule_Demo-000000?style=for-the-badge&logo=calendar&logoColor=white)](mailto:anthony@zero-day.ai?subject=Gibson%20Demo%20Request)
[![Discord](https://img.shields.io/badge/Join_Community-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mkqd6mU3)

---

**Zero-Day.ai** — Kubernetes-native agent development kit.

[anthony@zero-day.ai](mailto:anthony@zero-day.ai)

</div>
