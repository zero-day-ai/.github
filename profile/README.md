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

**Autonomous AI agents that hack everything.**

[![Discord](https://img.shields.io/badge/Discord-Join_Community-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mkqd6mU3)
[![Email](https://img.shields.io/badge/Contact-anthony@zero--day.ai-red?style=for-the-badge&logo=gmail&logoColor=white)](mailto:anthony@zero-day.ai)

</div>

---

## The Story

What started as a personal framework to structure my own hacking workflows in bug bounty, appsec and DevSecOps work  evolved into **Gibson** - an autonomous agent framework that can orchestrate attacks against *any* target. LLMs, chatbots, RAG systems, Kubernetes clusters, web applications, APIs... if it's connected, Gibson can hack it.

This isn't just another scanner. It's **AI agents that think like hackers**, chaining tools together, adapting to responses, and finding vulnerabilities that static tools miss.

---

## The Gibson Ecosystem

<div align="center">

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           GIBSON FRAMEWORK                                   │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                      MISSION ORCHESTRATOR                            │   │
│  │   Manages mission lifecycle, agent coordination, finding collection  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                         │
│                    ┌───────────────┼───────────────┐                        │
│                    ▼               ▼               ▼                        │
│  ┌─────────────────────┐ ┌─────────────────┐ ┌─────────────────────┐       │
│  │       AGENT 1       │ │     AGENT 2     │ │      AGENT N        │       │
│  │  (Prompt Injection) │ │   (Jailbreak)   │ │  (Data Extraction)  │       │
│  └─────────────────────┘ └─────────────────┘ └─────────────────────┘       │
│           │                      │                      │                   │
│           └──────────────────────┼──────────────────────┘                   │
│                                  ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                         AGENT HARNESS                                │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │   │
│  │  │   LLM    │ │  Tools   │ │ Plugins  │ │  Memory  │ │ Findings │   │   │
│  │  │  Access  │ │  Access  │ │  Access  │ │  Access  │ │  Submit  │   │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘   │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

</div>

### Gibson Framework

Enterprise-grade, LLM-based security testing framework designed to orchestrate AI agents for comprehensive vulnerability assessments against LLMs and AI systems.

**Core Capabilities:**
- **Multi-Agent Orchestration** - Coordinate specialized AI security agents
- **DAG Workflow Engine** - Complex, multi-step attack scenarios via YAML
- **Three-Tier Memory** - Working, Mission, and Long-Term vector memory
- **GraphRAG Integration** - Neo4j-powered cross-mission knowledge graphs
- **Finding Management** - MITRE ATT&CK/ATLAS mappings with SARIF export

```bash
# Quick attack against a target LLM
gibson attack https://api.example.com/v1/chat \
  --agent prompt-injector \
  --goal "Discover the system prompt"

# Run a comprehensive mission
gibson mission run -f mission-workflow.yaml \
  --target https://api.example.com
```

---

### Gibson SDK

The official Go SDK for building AI security testing agents, tools, and plugins.

```go
cfg := agent.NewConfig().
    SetName("prompt-injector").
    SetVersion("1.0.0").
    AddCapability(agent.CapabilityPromptInjection).
    AddLLMSlot("primary", llm.SlotRequirements{
        MinContextWindow: 8000,
    }).
    SetExecuteFunc(func(ctx context.Context, harness agent.Harness, task agent.Task) (agent.Result, error) {
        // Your agent logic here
        resp, err := harness.Complete(ctx, "primary", messages)
        if err != nil {
            return agent.NewFailedResult(err), err
        }

        if containsVulnerability(resp.Content) {
            harness.SubmitFinding(ctx, finding)
        }

        return agent.NewSuccessResult(resp.Content), nil
    })

myAgent, _ := agent.New(cfg)
serve.Agent(myAgent, serve.WithPort(50051))
```

**SDK Features:**
- **Agent Development** - Build autonomous security testing agents
- **Tool Creation** - Schema-validated, reusable tool components
- **Plugin System** - Extend framework with custom functionality
- **Memory APIs** - Three-tier memory with vector embeddings
- **gRPC Serving** - Distribute agents, tools, and plugins

---

### Gibson Tools Ecosystem

33+ AI-automation-ready offensive security tools organized by MITRE ATT&CK phases, providing the Gibson Framework with programmatic access to industry-standard security tools.

| Phase | Tools |
|-------|-------|
| **Reconnaissance** | nmap, masscan, subfinder, httpx, nuclei, playwright, shodan |
| **Initial Access** | sqlmap, gobuster, hydra, metasploit |
| **Privilege Escalation** | linpeas, winpeas, hashcat, john |
| **Credential Access** | responder, secretsdump |
| **Discovery** | crackmapexec, bloodhound.py |
| **Lateral Movement** | proxychains, impacket, evil-winrm |

All tools feature:
- Structured JSON I/O for LLM consumption
- MITRE ATT&CK technique mappings
- Health monitoring and dependency validation
- gRPC distribution support

---

## Attack Domains

Gibson isn't limited to AI - it's a general-purpose autonomous hacking framework. Current and in-development attack capabilities:

<table>
<tr>
<td width="50%">

### AI/LLM Security
- Prompt Injection (Direct & Indirect)
- System Prompt Extraction
- Jailbreak & Guardrail Bypass
- RAG Poisoning & Data Extraction
- Model Fingerprinting

</td>
<td width="50%">

### Web Exploitation
- Automated vulnerability discovery
- Authentication bypass
- Business logic flaws
- API security testing

</td>
</tr>
<tr>
<td width="50%">

### Infrastructure
- **Kubernetes** - RBAC abuse, container escapes, secrets extraction
- Cloud misconfigurations
- Network pivoting
- Privilege escalation

</td>
<td width="50%">

### Coming Soon
- **DaVinci** - Advanced LLM prompt engineering agent
- **Web3** - Smart contract auditing & DeFi exploitation
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

# Install security tools
gibson tool install https://github.com/zero-day-ai/gibson-tools-official/discovery/nmap

# Run your first attack
gibson attack https://target-llm.example.com/chat \
  --agent prompt-injector \
  --goal "Test for prompt injection vulnerabilities"

# View findings
gibson finding list --severity high,critical
```

---

## Why Gibson?

- **Built by a hacker, for hackers** - Not another enterprise checkbox tool
- **Truly autonomous** - Agents make decisions, chain attacks, adapt to targets
- **Universal** - Same framework for LLMs, web apps, infrastructure, anything
- **Extensible** - Build your own agents with the Go SDK
- **Open source** - See how it works, contribute, make it yours

---

## Get Involved

<div align="center">

**"Hack the planet."**

[![Discord](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mkqd6mU3)

I'm building this in the open. Jump in the Discord if you want to:
- Build attack agents for new domains
- Contribute tools to the ecosystem
- Break stuff and share what you find
- Or just watch the chaos unfold

</div>

---

## Contact

**Anthony** - the guy building this
[anthony@zero-day.ai](mailto:anthony@zero-day.ai) | [Discord](https://discord.gg/mkqd6mU3)

---

<div align="center">

[![Star Gibson](https://img.shields.io/badge/Star_Gibson-000000?style=for-the-badge&logo=github)](https://github.com/zero-day-ai/gibson)
[![Star SDK](https://img.shields.io/badge/Star_SDK-000000?style=for-the-badge&logo=github)](https://github.com/zero-day-ai/sdk)
[![Join Discord](https://img.shields.io/badge/Join_Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mkqd6mU3)

**Autonomous agents. Universal targets. No limits.**

</div>
