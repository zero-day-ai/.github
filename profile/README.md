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

**Autonomous LLM-orchestrated offensive security framework.**

[![Discord](https://img.shields.io/badge/Discord-Join_Community-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mkqd6mU3)
[![Email](https://img.shields.io/badge/Contact-anthony@zero--day.ai-red?style=for-the-badge&logo=gmail&logoColor=white)](mailto:anthony@zero-day.ai)

</div>

---

## The Story

What started as a personal framework to structure my own hacking workflows in bug bounty, appsec and DevSecOps work evolved into **Gibson** - an autonomous agent framework that can orchestrate attacks against *any* target. LLMs, chatbots, RAG systems, Kubernetes clusters, web applications, APIs... if it's connected, Gibson can hack it.

This isn't just another scanner. It's **AI agents that think like hackers**, chaining tools together, adapting to responses, and finding vulnerabilities that static tools miss.

---

## Core Repositories

<div align="center">

| Repository | Description |
|------------|-------------|
| [**gibson**](https://github.com/zero-day-ai/gibson) | Core framework - orchestration, harness, GraphRAG, missions |
| [**sdk**](https://github.com/zero-day-ai/sdk) | Go SDK for building agents, tools, and plugins |
| [**tools**](https://github.com/zero-day-ai/tools) | Security tool wrappers (nmap, httpx, nuclei, etc.) |

</div>

---

## Architecture

<div align="center">

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           GIBSON FRAMEWORK                                   │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                      MISSION ORCHESTRATOR                            │   │
│  │   DAG workflows • Checkpointing • Constraints • Auto-dependencies    │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                         │
│                    ┌───────────────┼───────────────┐                        │
│                    ▼               ▼               ▼                        │
│  ┌─────────────────────┐ ┌─────────────────┐ ┌─────────────────────┐       │
│  │       AGENT 1       │ │     AGENT 2     │ │      AGENT N        │       │
│  │   (Network Recon)   │ │   (Web Fuzzer)  │ │  (Cloud Auditor)    │       │
│  └─────────────────────┘ └─────────────────┘ └─────────────────────┘       │
│           │                      │                      │                   │
│           └──────────────────────┼──────────────────────┘                   │
│                                  ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                         AGENT HARNESS                                │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │   │
│  │  │   LLM    │ │  Tools   │ │ Plugins  │ │  Memory  │ │ GraphRAG │   │   │
│  │  │  Access  │ │ (Redis)  │ │  Access  │ │ 3-Tier   │ │ (Neo4j)  │   │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘   │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

</div>

---

## Gibson Framework

The core orchestration engine that coordinates autonomous security agents.

**Core Capabilities:**
- **Multi-Agent Orchestration** - Coordinate specialized AI security agents in DAG workflows
- **Three-Tier Memory** - Working (ephemeral), Mission (persistent), Long-Term (vector)
- **GraphRAG Integration** - Neo4j-powered knowledge graph with semantic search
- **Queue-Based Tools** - Redis-distributed tool execution for horizontal scaling
- **Finding Management** - MITRE ATT&CK mappings with full provenance

```bash
# Quick attack against a target
gibson attack --target my-app --agent network-mapper

# Run a comprehensive mission
gibson mission run recon.yaml --target my-app

# View findings
gibson finding list --severity high,critical
```

---

## Gibson SDK

The official Go SDK for building agents, tools, and plugins.

```go
type MyAgent struct{}

func (a *MyAgent) Name() string { return "my-agent" }

func (a *MyAgent) LLMSlots() []agent.SlotDefinition {
    return []agent.SlotDefinition{
        agent.NewSlotDefinition("primary", "Main reasoning LLM", true).
            WithConstraints(agent.SlotConstraints{
                MinContextWindow: 8000,
                RequiredFeatures: []string{agent.FeatureToolUse},
            }),
    }
}

func (a *MyAgent) Execute(ctx context.Context, task agent.Task, h agent.Harness) (agent.Result, error) {
    // Use LLM
    resp, err := h.Complete(ctx, "primary", messages)

    // Execute tools via Redis queue
    result, _ := h.ExecuteTool(ctx, "nmap", &pb.NmapRequest{Target: target})

    // Submit findings to GraphRAG
    h.SubmitFinding(ctx, agent.Finding{
        Title:    "Vulnerability Found",
        Severity: agent.SeverityHigh,
    })

    return agent.NewResult(task.ID).Complete(output), nil
}

func main() {
    serve.Agent(&MyAgent{}, serve.WithPort(50051))
}
```

**SDK Features:**
- **Agent Development** - LLM slots, harness access, finding submission
- **Tool Wrappers** - Protocol Buffers I/O, queue-based workers
- **Plugin System** - Stateful service integrations
- **GraphRAG Types** - Type-safe domain entities (Host, Port, Finding, etc.)
- **Memory APIs** - Three-tier memory with vector embeddings

---

## Gibson Tools

Security tool wrappers with structured I/O for agent consumption.

| Category | Tools |
|----------|-------|
| **Discovery** | nmap, masscan |
| **Reconnaissance** | httpx, nuclei, subfinder |
| **Fingerprinting** | wappalyzer, whatweb, sslyze, testssl |

All tools feature:
- Protocol Buffers for type-safe I/O
- Automatic GraphRAG population
- MITRE ATT&CK technique mappings
- Health monitoring and capability reporting
- Redis queue-based distributed execution

---

## Attack Domains

Gibson is a general-purpose autonomous hacking framework:

<table>
<tr>
<td width="50%">

### Network & Infrastructure
- Automated host/port discovery
- Service fingerprinting
- Kubernetes security testing
- Cloud misconfiguration auditing

</td>
<td width="50%">

### Web & API
- Vulnerability discovery
- Authentication bypass
- Business logic flaws
- API security testing

</td>
</tr>
<tr>
<td width="50%">

### AI/LLM Security
- Prompt injection testing
- System prompt extraction
- Jailbreak detection
- RAG poisoning analysis

</td>
<td width="50%">

### Coming Soon
- Smart contract auditing
- IoT security testing
- More attack chains...

</td>
</tr>
</table>

---

## Getting Started

```bash
# Install Gibson CLI
go install github.com/zero-day-ai/gibson/cmd/gibson@latest

# Initialize configuration
gibson init

# Start the daemon
gibson daemon start

# Add a target
gibson target add my-app --type http_api

# Run your first attack
gibson attack --target my-app --agent network-mapper

# View findings
gibson finding list
```

---

## Why Gibson?

- **Built by a hacker, for hackers** - Not another enterprise checkbox tool
- **Truly autonomous** - Agents make decisions, chain attacks, adapt to targets
- **Universal** - Same framework for LLMs, web apps, infrastructure, anything
- **Extensible** - Build your own agents with the Go SDK
- **Open source** - Apache 2.0 licensed

---

## Get Involved

<div align="center">

**"Hack the planet."**

[![Discord](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mkqd6mU3)

Jump in the Discord if you want to:
- Build attack agents for new domains
- Contribute tools to the ecosystem
- Break stuff and share what you find

</div>

---

## Contact

**Anthony** - [anthony@zero-day.ai](mailto:anthony@zero-day.ai) | [Discord](https://discord.gg/mkqd6mU3)

---

<div align="center">

[![Star Gibson](https://img.shields.io/badge/Star_Gibson-000000?style=for-the-badge&logo=github)](https://github.com/zero-day-ai/gibson)
[![Star SDK](https://img.shields.io/badge/Star_SDK-000000?style=for-the-badge&logo=github)](https://github.com/zero-day-ai/sdk)
[![Star Tools](https://img.shields.io/badge/Star_Tools-000000?style=for-the-badge&logo=github)](https://github.com/zero-day-ai/tools)

**Autonomous agents. Universal targets. No limits.**

</div>
