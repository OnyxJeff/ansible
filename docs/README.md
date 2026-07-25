# OnyxNet Infrastructure Documentation

## Overview

This documentation repository serves as the operational manual for the OnyxNet infrastructure.

OnyxNet is a self-hosted environment built around Infrastructure as Code (IaC), automation, observability, and recoverability. Physical servers, Raspberry Pis, virtual machines, Linux containers, and services are managed through Ansible and maintained through version-controlled configuration.

The goal of this documentation is:

> A failed system should be replaceable with new hardware or a clean operating environment and restored to a production-ready state using automation and documented procedures.

This documentation exists alongside the infrastructure code and should be treated as part of the infrastructure itself.

---

## Getting Started

## Getting Started

If you are new to OnyxNet, read the documentation in the following order:

1. Core/CORE-00-Standards.md
2. Core/CORE-01-Architecture.md
3. Core/CORE-02-Networking.md
4. Core/CORE-03-Security.md
5. Core/CORE-04-Monitoring.md

Once familiar with the infrastructure, continue with the relevant Service and Operations documentation.

---

## Core Principles

Infrastructure standards and operatoinal conventions are defined in `docs/Core/CORE-00-Standards.md`.

---

## Documentation Structure

The documentation is organized by responsibility rather than deployment order.

```text
docs/
│
├── README.md
│
├── Core/
│   ├── CORE-00-Standards.md
│   ├── CORE-01-Architecture.md
│   ├── CORE-02-Networking.md
│   ├── CORE-03-Security.md
│   └── CORE-04-Monitoring.md
│
├── Services/
│   ├── High-Availability-DNS.md
│   ├── Transmission.md
│   ├── NetBox.md
│   ├── Mealie.md
│   └── ...
│
├── Operations/
│   ├── OPS-Add-New-Host.md
│   ├── OPS-Update-Cluster.md
│   ├── OPS-Replace-Raspberry-Pi.md
│   └── OPS-Disaster-Recovery.md
│
└── assets/
    ├── images/
    │   └── logo.png
    ├── topology-maps/
    │   ├── network-topology.drawio
    │   ├── network-topology.png
    │   └── ...
    └── ...
```

---

## Directory Purpose

| Directory	    | Purpose                                                        |
|---------------|----------------------------------------------------------------|
| `Core/`       | Foundational infrastructure components used throughout OnyxNet |
| `Services/`   | Individual applications and service-specific documentation     |
| `Operations/` | Maintenance procedures, runbooks, and recovery documentation   |
| `assests/`    | Architecture diagrams and supporting visual documentation      |

---

## Documentation Standards

Infrastructure documentation standards are defined in `docs/Core/CORE-00-Standards.md`.

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