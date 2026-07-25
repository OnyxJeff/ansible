# OnyxNet Infrastructure Documentation
## Overview

This documentation repository serves as the operational manual for the OnyxNet infrastructure.

OnyxNet is a self-hosted environment built around Infrastructure as Code (IaC), automation, observability, and recoverability. Physical servers, Raspberry Pis, virtual machines, Linux containers, and services are managed through Ansible and maintained through version-controlled configuration.

The goal of this documentation is:

> A failed system should be replaceable with new hardware or a clean operating environment and restored to a production-ready state using automation and documented procedures.

This documentation exists alongside the infrastructure code and should be treated as part of the infrastructure itself.

---

## Core Principles

OnyxNet follows these principles:

### Infrastructure as Code

Infrastructure should be defined through automation whenever practical.

Manual configuration is acceptable during troubleshooting or initial discovery, but permanent changes should be migrated into Ansible roles, templates, or variables.

---

## Git as the Source of Truth

The desired state of the infrastructure exists within version-controlled repositories.

Changes should follow this process:

1. Modify configuration or automation.
2. Review changes.
3. Commit changes.
4. Deploy through Ansible.
5. Validate the result.
6. Update documentation if behavior changes.

---

## Idempotent Deployments

Ansible playbooks should safely run multiple times and converge on the desired state.

A successful maintenance run should result in minimal or no changes unless an intentional modification has been made.

---

## Standardization

Common patterns should be used throughout the environment:

- Consistent host naming
- Consistent inventory organization
- Standard Docker directory layouts
- Reusable Ansible roles
- Predictable service deployment methods

---

## Observability

Production services should provide visibility into their health and performance.

Where practical:

- Prometheus collects metrics
- Node Exporter provides host metrics
- Service-specific exporters expose application metrics
- Grafana provides visualization

---

## Recoverability

The environment should be rebuildable after hardware failure or catastrophic loss.

Documentation should include:

- Deployment procedures
- Dependencies
- Validation steps
- Recovery procedures
- Known limitations

---

## Documentation Structure

The documentation is organized by function rather than by deployment order.

```text
docs/
│
├── README.md
├── 00-Standards.md
│
├── Core/
│   ├── Base-Infrastructure.md
│   ├── Inventory.md
│   ├── Docker.md
│   └── Monitoring.md
│
├── Services/
│   ├── High-Availability-DNS.md
│   ├── Transmission.md
│   ├── NetBox.md
│   ├── Mealie.md
│   └── ...
│
├── Operations/
│   ├── Add-New-Host.md
│   ├── Update-Cluster.md
│   ├── Replace-Raspberry-Pi.md
│   └── Disaster-Recovery.md
│
└── images/
    ├── network-topology.drawio
    ├── network-topology.png
    └── ...
```

---

## Directory Purpose

| Directory	    | Purpose                                                        |
|---------------|----------------------------------------------------------------|
| `Core/`       | Foundational infrastructure components used throughout OnyxNet |
| `Services/`   | Individual applications and service-specific documentation     |
| `Operations/` | Maintenance procedures, runbooks, and recovery documentation   |
| `images/`	    | Architecture diagrams and supporting visual documentation      |

---

## Documentation Standards

Every infrastructure document should include the following sections when applicable:

### Purpose

What the component does and why it exists.

### Architecture

How the component fits into the larger OnyxNet environment.

### Requirements

Hardware, software, dependencies, and assumptions.

### Deployment

How the component is deployed through automation.

### Validation

How to verify the deployment succeeded.

### Monitoring

How health and performance are observed.

### Troubleshooting

Common failures and resolution steps.

### Recovery

How to rebuild or restore the component.

### Future Improvements

Potential enhancements that are intentionally not part of the current implementation.

---

## Infrastructure Workflow

Changes to OnyxNet generally follow this lifecycle:

```text
Design
  ↓
Document
  ↓
Automate
  ↓
Deploy
  ↓
Validate
  ↓
Monitor
  ↓
Maintain
```

Infrastructure changes should be documented before or during implementation to prevent undocumented production dependencies.

---

## Repository Relationship

The documentation describes the state and operation of the infrastructure repository:

```text
ansible/
│
├── docs/
├── inventory/
├── playbooks/
├── roles/
├── scripts/
└── identity/
```

The code defines the infrastructure.

The documentation explains how to operate and recover it.

Both are required for a maintainable environment.

---

## Status

This documentation represents the current production state of OnyxNet.

As infrastructure changes, the documentation should be updated alongside automation changes to ensure the environment remains understandable, maintainable, and recoverable.