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

### K8s-Native Autonomous Agent Platform

**Deploy AI agents inside your infrastructure. Security testing. Compliance. Operations. Anything.**

[![Discord](https://img.shields.io/badge/Discord-Join_Community-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mkqd6mU3)
[![Email](https://img.shields.io/badge/Contact-anthony@zero--day.ai-red?style=for-the-badge&logo=gmail&logoColor=white)](mailto:anthony@zero-day.ai)

</div>

---

## The Story

What started as a personal framework to structure my own hacking workflows in bug bounty, appsec, and DevSecOps work evolved into **Gibson**—an autonomous agent platform that can orchestrate operations against *any* target. LLMs, chatbots, RAG systems, Kubernetes clusters, web applications, APIs... if it's connected, Gibson can work with it.

This isn't just another scanner. It's **AI agents that think like operators**, chaining tools together, adapting to responses, and finding what static tools miss.

---

## What is Gibson?

Gibson is an **autonomous agent platform** that deploys directly into your Kubernetes clusters—behind your firewall, inside your CI/CD pipelines, in air-gapped environments.

```
CLI → Daemon (K8s workload) → Orchestrator → N Autonomous Agents → Targets
```

The orchestrator coordinates multiple AI agents that make decisions autonomously: chaining findings, pivoting between targets, and building a persistent knowledge graph. Give it mission objectives; it figures out the rest.

**Gibson is an agent factory.** The SDK enables building new agents in under an hour. Security testing agents. Compliance agents. Infrastructure assessment agents. Code review agents. Whatever your operation needs.

---

## Why Gibson Runs *Inside* Your Infrastructure

Every competitor in this space—XBOW, Horizon3.ai, Novee, Tenzai—runs from their cloud and scans externally.

**Gibson deploys on YOUR cluster.** This matters for:

- **Internal networks** - Test what external tools can't see
- **Air-gapped environments** - Data never leaves your network
- **CI/CD integration** - Security testing as a pipeline stage, not an afterthought
- **Compliance regimes** - ITAR, HIPAA, NYDFS, and other frameworks that require data stays internal
- **Purple team operations** - Red team attacks + blue team visibility in one platform

---

## The Platform

<div align="center">

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            GIBSON PLATFORM                                  │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                      MISSION ORCHESTRATOR                            │   │
│  │   Mission YAML → Autonomous decisions → Finding collection → Reports │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│         ┌──────────────────────────┼──────────────────────────┐            │
│         ▼                          ▼                          ▼            │
│  ┌─────────────┐           ┌─────────────┐            ┌─────────────┐      │
│  │  SECURITY   │           │ COMPLIANCE  │            │  YOUR AGENT │      │
│  │   AGENTS    │           │   AGENTS    │            │  (SDK)      │      │
│  └─────────────┘           └─────────────┘            └─────────────┘      │
│         │                          │                          │            │
│         └──────────────────────────┼──────────────────────────┘            │
│                                    ▼                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                         AGENT HARNESS                                │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │   │
│  │  │   LLM    │ │  Tools   │ │  Memory  │ │ Neo4j    │ │ Findings │   │   │
│  │  │  Access  │ │  33+     │ │ 3-Tier   │ │ GraphRAG │ │ & Reports│   │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘   │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    DEPLOYS TO ANY K8s CLUSTER                        │   │
│  │          EKS • GKE • AKS • k3s • OpenShift • Air-Gapped              │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

</div>

---

## CI/CD Integration

Gibson runs as a daemon in your cluster. Your pipelines send missions; the dashboard shows results.

<div align="center">

```
┌──────────────────────────────────────────────────────────────────────────────────────┐
│                                    YOUR INFRASTRUCTURE                               │
│                                                                                      │
│  ┌─────────────────┐         ┌─────────────────────────────────────────────────┐    │
│  │    CI/CD        │         │              KUBERNETES CLUSTER                  │    │
│  │  ┌───────────┐  │         │  ┌─────────────────────────────────────────┐    │    │
│  │  │  GitHub   │  │         │  │           GIBSON DAEMON                  │    │    │
│  │  │  Actions  │  │  gRPC   │  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  │    │    │
│  │  │───────────│──┼────────────▶│  │ Mission │  │  Agent  │  │  Agent  │  │    │    │
│  │  │  GitLab   │  │   API   │  │  │ Queue   │  │  Pool   │  │  Pool   │  │    │    │
│  │  │    CI     │  │         │  │  └────┬────┘  └────┬────┘  └────┬────┘  │    │    │
│  │  │───────────│  │         │  │       │            │            │       │    │    │
│  │  │  Jenkins  │  │         │  │       └────────────┼────────────┘       │    │    │
│  │  └───────────┘  │         │  │                    ▼                    │    │    │
│  │        │        │         │  │  ┌─────────────────────────────────┐    │    │    │
│  │        │        │         │  │  │      FINDINGS & KNOWLEDGE       │    │    │    │
│  │        ▼        │         │  │  │  ┌─────────┐      ┌─────────┐   │    │    │    │
│  │  gibson mission │         │  │  │  │ Neo4j   │      │ Reports │   │    │    │    │
│  │  submit -f      │         │  │  │  │ GraphRAG│      │ (SARIF) │   │    │    │    │
│  │  mission.yaml   │         │  │  │  └─────────┘      └─────────┘   │    │    │    │
│  │                 │         │  │  └─────────────────────────────────┘    │    │    │
│  └─────────────────┘         │  └─────────────────────────────────────────┘    │    │
│                              │                       │                          │    │
│                              └───────────────────────┼──────────────────────────┘    │
│                                                      │                               │
│                                                      ▼                               │
│                              ┌───────────────────────────────────────────────┐       │
│                              │              GIBSON DASHBOARD                  │       │
│                              │  ┌─────────┐  ┌─────────┐  ┌─────────────┐    │       │
│                              │  │ Mission │  │Findings │  │   Agent     │    │       │
│                              │  │ Status  │  │  View   │  │  Metrics    │    │       │
│                              │  └─────────┘  └─────────┘  └─────────────┘    │       │
│                              └───────────────────────────────────────────────┘       │
│                                                                                      │
└──────────────────────────────────────────────────────────────────────────────────────┘
```

</div>

```yaml
# .github/workflows/security.yml
- name: Run Gibson Security Mission
  env:
    GIBSON_DAEMON_ADDRESS: gibson.internal:50051
  run: |
    gibson mission run missions/full-assessment.yaml
```

---

## Use Cases

Gibson agents aren't limited to pentesting. The platform supports any autonomous operational task:

| Domain | What Gibson Does |
|--------|------------------|
| **Continuous Pentesting** | Autonomous security testing integrated into CI/CD pipelines |
| **Compliance Monitoring** | Evidence collection, continuous audit readiness, control validation |
| **Attack Surface Discovery** | API discovery, living architecture documentation, asset inventory |
| **Infrastructure Assessment** | K8s cluster health, drift monitoring, configuration auditing |
| **Incident Investigation** | Security log triage, automated threat hunting, anomaly detection |
| **Code Security** | Automated code review, vulnerability remediation suggestions |
| **DR Validation** | Disaster recovery testing, failover verification |

---

## For Bug Bounty Hunters

**Gibson is free for bug bounty research.** Use it, find vulnerabilities, keep all the rewards. No commercial license needed.

```bash
# Install Gibson CLI
go install github.com/zero-day-ai/gibson/cmd/gibson@latest

# Initialize and run
gibson init
gibson attack https://target.example.com \
  --agent recon-chain \
  --goal "Full attack surface discovery and vulnerability assessment"

# Export findings for report
gibson finding export --format markdown
```

The only restriction: you can't offer Gibson itself as a service to others. That requires a commercial license.

---

## For Enterprises & Consulting Firms

**Turn your consultants into supervisors, not operators.**

Gibson transforms how security assessments, compliance audits, and infrastructure reviews get delivered:

- **3x throughput** - Same team, triple the engagements
- **Faster delivery** - Weeks become days
- **Higher margins** - Less human hours per deliverable
- **Continuous service** - Monthly retainers, not point-in-time assessments
- **Competitive differentiation** - "AI-powered delivery" while competitors throw bodies at problems

### Deployment Options

| Package | What You Get |
|---------|--------------|
| **Managed Deployment** | We deploy Gibson in your cluster, tune agents for your environment, train your team |
| **Integration Services** | CI/CD pipeline integration, custom agent development, reporting dashboards |
| **Ongoing Operations** | Monthly agent tuning, new capability deployment, priority support |

**[Contact for pricing →](mailto:anthony@zero-day.ai)**

---

## The Agent SDK

Build production agents in under an hour:

```go
cfg := agent.NewConfig().
    SetName("compliance-auditor").
    SetVersion("1.0.0").
    AddCapability(agent.CapabilityCompliance).
    SetExecuteFunc(func(ctx context.Context, harness agent.Harness, task agent.Task) (agent.Result, error) {
        // Agent autonomously collects compliance evidence
        evidence, err := harness.Tools().Execute(ctx, "kubectl",
            "get", "networkpolicies", "-A", "-o", "json")

        // Analyze against compliance framework
        findings := analyzeCompliance(evidence, "CIS-K8s-1.8")

        for _, f := range findings {
            harness.SubmitFinding(ctx, f)
        }

        return agent.NewSuccessResult("Audit complete"), nil
    })

myAgent, _ := agent.New(cfg)
serve.Agent(myAgent, serve.WithPort(50051))  // gRPC distribution
```

**SDK Capabilities:**
- Three-tier memory (working, mission, long-term vector)
- Neo4j GraphRAG for cross-mission intelligence
- 33+ pre-built security tools with structured JSON I/O
- MITRE ATT&CK/ATLAS mappings and SARIF export
- gRPC serving for distributed agent deployment

---

## Attack Domains

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

### Web & API
- Automated vulnerability discovery
- Authentication bypass
- Business logic exploitation
- API security testing

</td>
</tr>
<tr>
<td width="50%">

### Infrastructure
- **Kubernetes** - RBAC abuse, container escapes, secrets extraction
- Cloud misconfigurations (AWS, GCP, Azure)
- Network pivoting & lateral movement
- Privilege escalation chains

</td>
<td width="50%">

### Operations (Beyond Red Team)
- Compliance evidence collection
- Configuration drift detection
- Attack surface monitoring
- Automated remediation

</td>
</tr>
</table>

---

## Get Started

```bash
# Install
go install github.com/zero-day-ai/gibson/cmd/gibson@latest

# Initialize
gibson init

# Run a security mission
gibson mission run -f mission.yaml --target https://api.example.com

# Build your own agent
gibson agent scaffold my-custom-agent
```

---

## License

Gibson is released under the **Business Source License (BSL 1.1)**—the same license used by MariaDB, HashiCorp, Sentry, and CockroachDB.

- **Bug bounty hunters**: Use freely, keep all rewards
- **Internal use**: Requires commercial license
- **Offering as a service**: Requires commercial license
- **After 4 years**: Converts to Apache 2.0

---

<div align="center">

## Let's Talk

**Building a security practice? Need continuous assessment capabilities? Want to deploy AI agents in your infrastructure?**

[![Schedule a Demo](https://img.shields.io/badge/Schedule_Demo-000000?style=for-the-badge&logo=calendar&logoColor=white)](mailto:anthony@zero-day.ai?subject=Gibson%20Demo%20Request)
[![Discord](https://img.shields.io/badge/Join_Community-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mkqd6mU3)

---

**Anthony Santangelo** — Building autonomous agents that operate inside your infrastructure.

Secret clearance | K8s/DevSecOps background | DoD & Financial Services experience

[anthony@zero-day.ai](mailto:anthony@zero-day.ai)

</div>
