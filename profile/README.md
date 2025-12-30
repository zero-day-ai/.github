#

<div align="center">

```
███████╗███████╗██████╗  ██████╗       ██████╗  █████╗ ██╗   ██╗    █████╗ ██╗
╚══███╔╝██╔════╝██╔══██╗██╔═══██╗      ██╔══██╗██╔══██╗╚██╗ ██╔╝   ██╔══██╗██║
  ███╔╝ █████╗  ██████╔╝██║   ██║█████╗██║  ██║███████║ ╚████╔╝    ███████║██║
 ███╔╝  ██╔══╝  ██╔══██╗██║   ██║╚════╝██║  ██║██╔══██║  ╚██╔╝     ██╔══██║██║
███████╗███████╗██║  ██║╚██████╔╝      ██████╔╝██║  ██║   ██║   ██╗██║  ██║██║
╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝       ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═╝╚═╝
```

</div>

<div align="center">

**"Mess with the best, die like the rest."**

[![Discord](https://img.shields.io/badge/Discord-Join_Community-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mkqd6mU3)
[![Email](https://img.shields.io/badge/Contact-anthony@zero--day.ai-red?style=for-the-badge&logo=gmail&logoColor=white)](mailto:anthony@zero-day.ai)

</div>

---

## Democratizing AI/ML Security Testing

**Zero-Day.AI** is building the future of offensive AI/ML enterprise testing systems. We're hackers at heart who believe that understanding how AI systems break is the key to making them unbreakable.

Our mission: **Democratize AI security testing** so every developer, security researcher, and enterprise can validate their AI systems before deployment.

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

<table>
<tr>
<td width="50%">

### Prompt-Based Attacks
- Direct/Indirect Prompt Injection
- System Prompt Extraction
- Context Window Manipulation
- Jailbreak & Guardrail Bypass

</td>
<td width="50%">

### System Integration
- Model Fingerprinting
- API Security Testing
- Resource Exhaustion
- Error Handling Validation

</td>
</tr>
<tr>
<td width="50%">

### Data Security
- Training Data Extraction
- PII Leakage Detection
- Credential Harvesting
- Sensitive Information Disclosure

</td>
<td width="50%">

### Model Security
- Model Denial of Service
- Insecure Output Handling
- Adversarial Techniques
- Architecture Discovery

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

## Why Zero-Day.AI?

- **Hacker Mindset** - Built by security researchers who understand real attack vectors
- **Enterprise-Grade** - Go-based architecture with gRPC, observability, and DAG workflows
- **AI-Native** - Purpose-built for LLM and AI system security testing
- **Open Source** - Transparent development with community-driven research
- **Extensible** - SDK for custom agents, tools, and plugins

---

## Join the Community

<div align="center">

### **"The only way to truly understand a system is to attack it."**

[![Discord](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mkqd6mU3)

Connect with security researchers, AI engineers, and fellow hackers building the future of AI security.

**Contribute:**
- Develop new attack agents and techniques
- Build tools for the Gibson ecosystem
- Share real-world vulnerability research
- Help democratize AI security testing

</div>

---

## Contact

**Anthony** - Founder
[anthony@zero-day.ai](mailto:anthony@zero-day.ai) | [Discord](https://discord.gg/mkqd6mU3)

---

## Responsible Security Research

- All tools designed for authorized testing only
- Built-in rate limiting and safety controls
- Clear ethical use guidelines
- Responsible disclosure practices

---

<div align="center">

[![Star Gibson](https://img.shields.io/badge/Star_Gibson-000000?style=for-the-badge&logo=github)](https://github.com/zero-day-ai/gibson)
[![Star SDK](https://img.shields.io/badge/Star_SDK-000000?style=for-the-badge&logo=github)](https://github.com/zero-day-ai/sdk)
[![Join Discord](https://img.shields.io/badge/Join_Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mkqd6mU3)

**Democratizing AI security through hacker-driven research.**

</div>
