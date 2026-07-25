---
title: "Infrastructure Standards"
document_id: "CORE-00"
category: "Core"
status: "Active"
version: "1.0"
author: "Jeff"
created: "2026-07-25"
last_updated: "2026-07-25"
review_cycle: "Annual"
---

# OnyxNet Infrastructure Standards

## Table of Contents

- [1. Purpose](#1-purpose)
- [2. Naming Standards](#2-naming-standards)
- [3. Network Standards](#3-network-standards)
- [4. Ansible Standards](#4-ansible-standards)
- [5. Docker Standards](#5-docker-standards)
- [6. Monitoring Standards](#6-monitoring-standards)
- [7. Secrets Management](#7-secrets-management)
- [8. Documentation Standards](#8-documentation-standards)
  - [Documentation Location](##documentation-location)
  - [Document Naming Standards](##document-naming-standards)
  - [Infrastructure Documentation](##infrastructure-documentation)
  - [Service Documentation](##service-documentation)
  - [Ansible Documentation](##ansible-documentation)
  - [Docker Documentation](##docker-documentation)
  - [Change Documentation](##change-documentation)
- [9. Validation Standards](#9-validation-standards)
- [10. Future Expansion](#10-future-expansion)

## 1. Purpose

This document defines the standards and conventions used throughout the OnyxNet infrastructure.

These standards exist to maintain consistency, simplify troubleshooting, and ensure the environment remains maintainable as new hardware, services, and automation are introduced.

All infrastructure components should follow these standards unless there is a documented reason for deviation.

### Infrastructure Philosophy

OnyxNet is managed using an Infrastructure as Code approach.

The desired state of the environment should be represented through:

- Ansible automation
- Version-controlled configuration
- Documented architecture decisions
- Repeatable deployment procedures

Manual changes are acceptable for:

- Troubleshooting
- Initial testing
- Emergency recovery

Permanent configuration changes should be migrated into automation.

--- 

## 2. Naming Standards

Hostnames should identify **where a system exists and what type of infrastructure it represents.**

Naming conventions are based on infrastructure placement rather than service criticality alone.

### Physical Infrastructure

Physical devices use the `svr-` prefix.

`svr-` indicates that the device is physical hardware and is not hosted inside a virtualization platform.

Examples:

| Hostname    | Type                 | Purpose                   |
|-------------|----------------------|---------------------------|
| svr-odin    | Raspberry Pi 4       | Pi-hole / monitoring node |
| svr-forseti | Raspberry Pi Zero 2W | Pi-hole / backup DNS node |
| svr-muninn  | TrueNAS server       | Storage platform          |

A physical device remains `svr-` regardless of the services it provides.

### Aesir Cluster Services

Virtualized production services use the `svc-` prefix.

`svc-` indicates a virtual machine or Linux container hosted on the Aesir cluster.

Aesir is the production services cluster and hosts critical infrastructure workloads.

Examples:

| Hostname   | Platform    | Purpose                               |
|------------|-------------|---------------------------------------|
| svc-pihole | Proxmox LXC | Production Pi-hole instance           |
| svc-gitea  | Proxmox LXC | Git hosting                           |
| svc-netbox | Proxmox LXC | Infrastructure documentation platform |

The `svc-` prefix identifies workloads belonging to the production services environment.

### Vanir Cluster Systems

Homelab and experimental systems use the `hml-` prefix.

`hml-` indicates a workload hosted on the Vanir cluster.

Vanir is the homelab and experimentation environment.

Examples:

| Hostname     | Platform    | Purpose                     |
|--------------|-------------|-----------------------------|
| hml-pihole   | Proxmox LXC | Secondary Pi-hole instance  |
| hml-streamer | Proxmox LXC | Streaming experimentation   |
| hml-simc     | Proxmox VM  | SimulationCraft environment |

The `hml-` prefix is determined by cluster placement, not whether the workload is temporary.

### Personal Devices

Personal systems are maintained separately from infrastructure naming, and normally follow a unified naming scheme per person whom the devices belong to. (ie. `Squall`, `Tempest`, `Zephyr`)

Examples:

| Hostname | Purpose               |
|----------|-----------------------|
| squall   | Personal workstation  |
| tempest  | Personal streaming PC |
| zephyr   | Personal laptop       |

Personal devices are not managed as infrastructure services unless explicitly added.

### Cluster Standards

OnyxNet contains multiple compute environments with distinct purposes.

#### Aesir Cluster

Aesir is the primary production services cluster.

Purpose:

- Vital services
- Production workloads
- Persistent infrastructure applications

Platform:

- Three-node Proxmox cluster

Naming:

- Virtualized workloads use the svc- prefix.

Examples:

```text
Aesir Cluster
│
├── Proxmox Nodes
│
├── svc-pihole
├── svc-gitea
├── svc-netbox
└── svc-mealie
```

#### Vanir Cluster

Vanir is the homelab and experimental cluster.

Purpose:

- Testing
- Development
- Non-critical workloads
- Experimental services

Platform:

- Single-node Proxmox cluster

Naming:

- Virtualized workloads use the hml- prefix.

Examples:

```text
Vanir Cluster
│
├── Proxmox Node
│
├── hml-pihole
├── hml-streamer
├── hml-spool
└── hml-simc
```

---

## 3. Network Standards

Network documentation should identify:

- Device hostname
- IP address
- VLAN assignment
- Cluster membership
- Service purpose

Network placement should reflect the function of the system.

### VLAN Documentation

Current VLAN assignments:

| VLAN | Name      | Purpose               |
|------|-----------|-----------------------|
| 10   | Valhalla  | Management            |
| 25   | Jotunheim | IoT                   |
| 50   | Helheim   | Security              |
| 99   | Vanaheim  | Guest                 |
| 100  | Midgard   | Data                  |
| 1000 | Asgard    | Server infrastructure |

### Cluster Network Placement

Cluster membership should be documented alongside services.

Example:

| Cluster                 | Purpose                | Host Prefix |
|-------------------------|------------------------|-------------|
| Aesir                   | Production services    | `svc-`      |
| Vanir                   | Homelab / experimental | `hml-`      |
| Physical infrastructure | Hardware systems       | `svr-`      |

### Naming Decision Summary

| Prefix | Meaning                        | Location      |
|--------|--------------------------------|---------------|
| `svr-` | Physical hardware              | Anywhere      |
| `svc-` | Virtualized production service | Aesir cluster |
| `hml-` | Virtualized homelab workload   | Vanir cluster |

These prefixes describe infrastructure placement and ownership, not temporary versus permanent status.

---

## 4. Ansible Standards
### Purpose

Ansible is the primary configuration management and deployment system for OnyxNet.

All repeatable infrastructure configuration should be implemented through Ansible whenever practical.

The goal is to maintain a predictable, repeatable, and recoverable environment where systems can be rebuilt without relying on undocumented manual steps.

### Repository Structure

The Ansible repository follows this structure:

```text
ansible/
│
├── ansible.cfg
├── inventory/
├── playbooks/
├── roles/
├── scripts/
├── identity/
└── docs/
```

### Inventory

The inventory defines the managed infrastructure.

Inventory should describe:

- Hosts
- Groups
- Infrastructure relationships
- Connection information
- Configuration scope

Primary inventory files:

```text
inventory/
├── hosts.yml
├── group_vars/
└── host_vars/
```

### Inventory Group Standards

Groups should represent logical infrastructure relationships.

Examples:

```ini
servers:
  children:
    raspberries:
    aesir_cluster:
    vanir_cluster:
```

Groups should describe:

- Physical location
- Cluster membership
- Device category
- Service grouping

Avoid groups based solely on temporary tasks.

### Variable Scope Standards

Variables should be placed according to their scope.

#### Global Variables

Location:

```ini
inventory/group_vars/all.yml
```

Used for environment-wide defaults.

Examples:

```ini
docker_stack_dir: /opt/docker
```

Global variables should be limited to values that apply universally.

#### Group Variables

Location:

```ini
inventory/group_vars/<group>.yml
```

Used for shared configuration.

Examples:

```ini
inventory/group_vars/potent-pis.yml
```

Example:

```ini
enable_docker: true
enable_dockprom: true
```

Group variables should define common behavior for a class of systems.

#### Host Variables

Location:

```ini
inventory/host_vars/<hostname>.yml
```

Used for individual exceptions.

Example:

```ini
inventory/host_vars/svr-odin.yml
```

Example:

```ini
enable_pihole: true
```

Host variables should be used when a system differs from the rest of its group.

### Feature Flag Standards

Roles should be enabled through boolean variables.

Example:

```ini
enable_docker: true
enable_pihole: true
enable_dockprom: true
```

Defaults should disable functionality.

Example:

```ini
enable_pihole: false
```

A host receives functionality by enabling features through inventory variables.

### Playbook Standards

The primary deployment playbook is:

`playbooks/site.yml`

The site playbook is responsible for orchestrating roles.

Example:

```ini
roles:
  - base

  - role: docker
    when: enable_docker | default(false)

  - role: dockprom
    when: enable_dockprom | default(false)

  - role: pihole
    when: enable_pihole | default(false)
```

Roles should not determine their own deployment scope.

The inventory determines what is deployed where.

### Role Standards

Roles should be:

- Modular
- Idempotent
- Self-contained
- Repeatable

Standard role structure:

```text
roles/
└── service/
    ├── defaults/
    ├── files/
    ├── handlers/
    ├── tasks/
    ├── templates/
    └── vars/
```

### Role Responsibilities

A role should:

- Install required packages
- Deploy configuration
- Configure services
- Start or enable services
- Validate deployment

A role should not:

- Modify unrelated services
- Assume a specific host unless required
- Contain environment-specific values

### Handlers

Handlers should be used for service restarts and reloads.

Example:

```text
notify:
  - Restart keepalived
```

Services should only restart when configuration changes require it.

### Idempotency Standards

Every role should safely run multiple times.

A second execution with no configuration changes should result in:

`changed=0`

Tasks should avoid unnecessary changes.

### Secrets Standards

Sensitive data should never exist directly inside playbooks or templates.

Approved methods:

- Ansible Vault
- Environment files excluded from Git
- External secret management systems

Examples:

```ini
pihole_web_password: !vault |
  $ANSIBLE_VAULT;1.1;AES256
```

Secrets include:

- Passwords
- API tokens
- Webhooks
- Authentication credentials

### Deployment Validation

A successful Ansible run only confirms configuration deployment.

Each role should include validation where practical.

Examples:

#### Docker

Verify:

- Container exists
- Container is running
- Ports are available

#### Pi-hole

Verify:

- Pi-hole binary exists
- DNS service is running
- Metrics exporter is available

#### Monitoring

Verify:

- Prometheus target is reachable
- Exporters expose metrics

### Change Workflow

Ansible changes should follow:

```text
Modify
  ↓
Test
  ↓
Deploy
  ↓
Validate
  ↓
Document
```

Production changes should not be considered complete until:

- Automation is updated
- Documentation reflects the change
- Validation has been completed

### Maintenance Playbooks

Maintenance actions should be separated from deployment.

Examples:

```text
playbooks/
├── site.yml
└── maintenance/
    └── update-all.yml
```

Deployment and maintenance tasks should not be mixed unless there is a specific reason.

### Scripts

Helper scripts should:

- Be stored in scripts/
- Use Unix line endings
- Include a shebang
- Fail safely

Example:

```ini
#!/usr/bin/env bash

set -euo pipefail
```

Scripts should automate repetitive administrative tasks rather than replace Ansible functionality.

### Ansible Design Summary

| Principle       | Implementation         |
|-----------------|------------------------|
| Source of truth | Inventory + Git        |
| Deployment      | Roles + playbooks      |
| Configuration   | Variables              |
| Secrets         | Ansible Vault          |
| Scope control   | Feature flags          |
| Repeatability   | Idempotent roles       |
| Validation      | Post-deployment checks |

---

## 5. Docker Standards
### Purpose

Docker is used as the primary application deployment platform for containerized workloads within OnyxNet.

Docker provides consistent application deployment, portability, and simplified lifecycle management.

Not all services are containerized. Services should be deployed using the method that best fits their operational requirements.

Examples:

- Pi-hole is installed natively due to its networking requirements.
- Keepalived is installed natively because it manages host-level networking.
- Application services are generally containerized.

### Docker Deployment Standards

Docker hosts are provisioned and maintained through Ansible.

Docker installation and configuration should not be performed manually unless required for troubleshooting or initial recovery.

The Ansible Docker role is responsible for:

- Installing Docker Engine
- Installing Docker Compose plugin
- Managing Docker user permissions
- Preparing hosts for container workloads

Docker capability is enabled through inventory variables.

Example:

`enable_docker: true`

### Docker Directory Standards

All Docker workloads use a standardized directory structure.

Primary Docker directory:

`/opt/docker`

Each application or stack receives its own directory.

Example:

```text
/opt/docker
├── dockprom
├── pihole-exporter
├── nebula-sync
└── transmission
```

Each stack directory should contain:

- Docker Compose files
- Environment files
- Configuration files
- Deployment documentation where applicable


### Docker Compose Standards

Docker Compose is the standard deployment method for multi-container applications.

Compose files should be stored in Ansible roles and deployed to hosts.

Example:

```text
roles/
└── service/
    └── files/
        └── docker-compose.yml
```

Deployment flow:

```text
Ansible Repository
        |
        v
Host /opt/docker
        |
        v
docker compose up -d
```

Docker Compose deployments should be:

- Repeatable
- Idempotent
- Version controlled

### Container Naming Standards

Container names should be explicit and descriptive.

Recommended format:

`<service-name>`

Examples:
```text
prometheus
nodeexporter
pihole_sqlite_exporter
nebula-sync
```

Container names should avoid:

- Random generated names
- Host-specific names
- Temporary identifiers

The hostname already identifies the physical location of the workload.

### Docker Networking Standards

Docker networking should be intentionally designed.

Default bridge networking should only be used when appropriate.

Services requiring direct host networking should explicitly document why.

Examples:

#### **Host Networking**

Used when a service requires direct access to host networking.

Examples:

- Node Exporter
- Network monitoring services

#### **Bridge Networking**

Used for application stacks that communicate internally.

Examples:

- Web applications
- Databases
- Supporting services

Network names should describe their purpose.

Example:

```text
networks:
  monitor-net:
    driver: bridge
```

### Port Management Standards

Container ports must be documented and managed to prevent conflicts.

Port assignments should consider:

- Existing services
- Host requirements
- Monitoring requirements
- External access needs

Examples:

| Service                 | Port | Purpose          |
|-------------------------|------|------------------|
| Prometheus              | 9090 | Metrics database |
| Node Exporter           | 9100 | Host metrics     |
| Pi-hole SQLite Exporter | 9617 | Pi-hole metrics  |
| Transmission            | 9001 | Web interface    |

Port conflicts should be resolved through documented changes rather than temporary workarounds.

### Persistent Storage Standards

Persistent application data must survive container recreation.

Storage should use one of:

- Docker named volumes
- Bind mounts
- Dedicated storage locations

Important application data should not exist only inside containers.

Example:

```text
volumes:
  prometheus_data:
```

Container recreation should not result in data loss.

### Environment File Standards

Sensitive or environment-specific values should not be stored directly in Compose files.

Use:

- `.env` files
- Ansible Vault
- Secret management systems

Examples:

```text
.env
docker-compose.yml
```

Sensitive information includes:

- Passwords
- Tokens
- API keys
- Webhooks

Secrets should never be committed to Git repositories.

### Docker Updates and Maintenance

Container updates should follow a controlled process.

Preferred workflow:

```text
Update image reference
        |
        v
Deploy through Ansible
        |
        v
Validate service
        |
        v
Document change
```

Avoid unmanaged container updates that bypass the Ansible repository.

### Portainer Standards

Portainer is used as a management interface and operational tool.

Portainer is not the primary source of truth.

The source of truth remains:

```text
Ansible Repository
        +
Version Control
```

Changes made directly through Portainer should be migrated back into Ansible where practical.

### Docker Recovery Standards

A Docker host should be recoverable using:

- Operating system installation
- Ansible repository
- Persistent storage backups
- Docker Compose definitions

Recovery process:

```text
Rebuild Host
      |
      v
Run Ansible
      |
      v
Restore Persistent Data
      |
      v
Start Containers
      |
      v
Validate Service
```

The objective is to recreate infrastructure without relying on undocumented manual configuration.

### Docker Design Summary

| Principle       | Implementation                 |
|-----------------|--------------------------------|
| Deployment      | Ansible + Docker Compose       |
| Location        | `/opt/docker`                  |
| Source of truth | Git-managed Ansible repository |
| Management UI   | Portainer                      |
| Persistent data | Volumes / bind mounts          |
| Secrets         | Vault / environment files      |
| Updates         | Controlled deployment          |
| Recovery        | Rebuild + restore              |

---

## 6. Monitoring Standards
#### Purpose

Monitoring provides visibility into the health, performance, and availability of OnyxNet infrastructure.

Monitoring should allow operators to:

- Identify failures quickly
- Understand system performance
- Detect resource exhaustion
- Validate service availability
- Support future alerting and automation

Monitoring infrastructure should be deployed consistently and managed through Ansible where practical.

### Monitoring Architecture

OnyxNet uses a distributed Prometheus architecture.

Each monitored Docker host runs its own local monitoring stack consisting of:

- Prometheus
- Node Exporter
- Optional service-specific exporters

Grafana is hosted separately and consumes Prometheus data sources.

Architecture:

```text
                    Grafana
                       |
        +--------------+--------------+
        |              |              |
        v              v              v

  Prometheus      Prometheus      Prometheus
   svr-odin       svr-forseti     svc-pihole

       |              |              |
       v              v              v

 Node Exporter   Node Exporter   Node Exporter
 Pi-hole Exporter Pi-hole Exporter
```

### Monitoring Design Principles
#### Distributed Collection

Each host should monitor itself whenever practical.

Benefits:

- A failed Prometheus instance only affects that host
- No single scrape server becomes a failure point
- Local troubleshooting remains possible
- New hosts can be added independently

A monitoring failure should not create a monitoring outage for all infrastructure.

### Centralized Visualization

Grafana provides centralized visualization.

Grafana is responsible for:

- Dashboards
- Data source management
- Visualization
- Future alert integrations

Grafana does not collect metrics directly.

Prometheus remains responsible for metric collection.

### Prometheus Standards

Prometheus should be deployed as a containerized service.

Standard image:

`prom/prometheus`

Prometheus configuration should be managed through Ansible.

Example location:

`/opt/docker/dockprom/prometheus/prometheus.yml`

#### Prometheus Labels

Each Prometheus instance must identify itself.

The external label should use the inventory hostname.

Example:

```text
external_labels:
  monitor: '{{ inventory_hostname }}'
```

This ensures metrics can be traced back to their originating system.

Example values:

```text
monitor="svr-odin"
monitor="svc-pihole"
monitor="hml-pihole"
```

### Node Exporter Standards

Node Exporter provides host-level metrics.

Node Exporter should be installed on monitored systems.

Collected metrics include:

- CPU utilization
- Memory usage
- Disk utilization
- Filesystem status
- Network statistics
- System load

Standard port:

`9100`

### Service Exporter Standards

Service-specific exporters may be deployed when additional visibility is required.

Examples:

| Exporter                | Purpose         | Port  |
|-------------------------|-----------------|-------|
| Node Exporter           | Host metrics    | 9100  |
| Pi-hole SQLite Exporter | DNS statistics  | 9617  |
| Transmission Exporter   | Torrent metrics | 19001 |

Exporters should only be deployed where the service exists.

### Pi-hole Monitoring Standards

Pi-hole instances are monitored individually.

Current Pi-hole monitoring:

VIP 10.100.0.9

```text
svr-odin
├── Prometheus
├── Node Exporter
└── Pi-hole SQLite Exporter

svc-pihole
├── Prometheus
├── Node Exporter
└── Pi-hole SQLite Exporter
```

```text
VIP 10.100.0.8

svr-forseti
├── Prometheus
├── Node Exporter
└── Pi-hole SQLite Exporter

hml-pihole
├── Prometheus
├── Node Exporter
└── Pi-hole SQLite Exporter
```

Monitoring the individual Pi-hole hosts rather than the VIP prevents loss of visibility if one node fails.

### Monitoring Configuration Standards

Prometheus scrape configurations should be generated through templates where possible.

Example:

```text
scrape_configs:

  - job_name: nodeexporter
    static_configs:
      - targets:
          - localhost:9100

  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090

  - job_name: pihole
    static_configs:
      - targets:
          - localhost:9617
```

Local exporters should be scraped locally.

### Grafana Standards

Grafana is hosted separately from individual monitoring nodes.

Grafana responsibilities:

- Dashboard storage
- Visualization
- Data source configuration
- User access

Grafana data sources should point to individual Prometheus instances.

Example:

```text
Prometheus - svr-odin
Prometheus - svr-forseti
Prometheus - svc-pihole
Prometheus - hml-pihole
```

### Monitoring Data Retention

Prometheus retention should be explicitly configured.

Current default:

`200h`

Retention requirements should consider:

- Storage capacity
- Query requirements
- Recovery requirements

Increasing retention should be balanced against available disk space.

### Monitoring Security Standards

Monitoring interfaces should not be exposed unnecessarily.

Requirements:

- Prometheus should remain internal
- Grafana access should be controlled
- Exporter ports should not be publicly accessible
- Firewall rules should restrict metric access where applicable

### Monitoring Expansion

Future monitoring additions may include:

- Alertmanager
- Discord notifications
- Proxmox metrics
- TrueNAS metrics
- UPS monitoring
- Network equipment monitoring
- Application health checks

Alerting should be implemented separately from metric collection.

### Monitoring Design Summary

| Component         | Standard                 |
|-------------------|--------------------------|
| Collection        | Distributed Prometheus   |
| Visualization     | Centralized Grafana      |
| Host metrics      | Node Exporter            |
| Service metrics   | Dedicated exporters      |
| Deployment        | Ansible + Docker         |
| Configuration     | Version controlled       |
| Failure isolation | Per-host monitoring      |
| Future alerts     | Alertmanager integration |

---

## 7. Secrets Management
#### Purpose

Secrets management defines how sensitive information is stored, accessed, deployed, and protected within OnyxNet.

Secrets must be handled in a way that allows infrastructure automation while preventing accidental exposure.

Sensitive information includes:

- Passwords
- API tokens
- Authentication keys
- Webhooks
- Encryption keys
- Private credentials

### Source of Truth

Infrastructure secrets should be managed through controlled, versioned systems.

Approved sources:

- Ansible Vault
- Protected environment files
- Dedicated secret management platforms (future)

Secrets should not be stored directly in:

- Playbooks
- Role tasks
- Templates
- Docker Compose files
- Public documentation
- Git repositories

### Ansible Vault Standards

Ansible Vault is the primary secret management method for infrastructure automation.

Example:

```text
pihole_web_password: !vault |
  $ANSIBLE_VAULT;1.1;AES256
```

Encrypted values may exist within:

- group_vars
- host_vars
- Role defaults when appropriate

Plaintext secrets should never be committed.

### Secret File Standards

Files containing secrets must be excluded from version control.

Examples:

```text
vault.secret
.env
*.pem
*.key
```

Repository exclusions should include:

`.gitignore`

Example:

```text
vault*
*.secret
*.pem
*.key
.env
```

### Docker Secret Standards

Docker Compose deployments should not contain plaintext credentials.

Avoid:

```text
environment:
  PASSWORD: MyPassword123
```

Preferred:

```text
environment:
  PASSWORD: ${PASSWORD}
```

with values stored in:

`.env`

or generated through Ansible templates.

### Environment File Standards

Environment files may be used for application configuration.

Example:

`/opt/docker/service/.env`

Environment files should:

- Be deployed through Ansible when appropriate
- Have restrictive permissions
- Never be publicly accessible
- Never be committed to Git

Recommended permissions:

`chmod 600 .env`

### Credential Rotation

Credentials should be rotated when:

- A credential is exposed
- A service is retired
- Access requirements change
- Personnel access changes

After rotation:

- Update secret storage
- Redeploy affected services
- Validate functionality
- Document the change

### Access Control

Access to secrets should follow the principle of least privilege.

Requirements:

- Users should only access required credentials
- Automation accounts should use dedicated keys where possible
- Administrative credentials should not be shared

### SSH Key Standards

SSH access should use key-based authentication.

Private keys should:

- Remain on trusted systems
- Never be stored in Git
- Never be shared through unsecured channels

Public keys may be managed through Ansible.

Example:

```text
identity/
├── automation/
└── users/
```

### Backup Requirements

Secret backups must be handled carefully.

Backups should include:

- Encrypted Ansible Vault data
- Required recovery keys
- Documentation of restoration procedures

Unencrypted secret backups should not exist.

### Recovery Standards

A complete infrastructure recovery requires:

- Ansible repository
- Vault password or recovery mechanism
- Encrypted secret backups
- Access to required external services

Recovery documentation should identify:

- Which secrets are required
- Where they are stored
- How they are restored

### Future Secret Management

Future improvements may include:

- HashiCorp Vault
- External Secrets Operator
- Hardware-backed key storage
- Automated credential rotation

Any future solution should continue supporting:

- Infrastructure automation
- Auditing
- Recovery
- Least privilege access

### Secrets Management Summary

| Principle          | Implementation            |
|--------------------|---------------------------|
| Primary system     | Ansible Vault             |
| Git safety         | Excluded secret files     |
| Docker credentials | Environment files / Vault |
| SSH access         | Key-based authentication  |
| Backups            | Encrypted only            |
| Rotation           | Documented process        |
| Future expansion   | Dedicated secret platform |

---

## 8. Documentation Standards
### Documentation Location

Documentation should be organized by purpose to ensure information is easy to locate and maintain.

Standard documentation structure:

```text
docs/
├── Core/
├── Operations/
└── Services/
```
- **Core** contains foundational standards, architecture, naming, networking, and design documentation.
- **Operations** contains procedures, maintenance, recovery, and operational workflows.
- **Services** contains documentation for individual applications, infrastructure services, and workloads.

### Document Naming Standards

Documents should use descriptive names that identify their purpose and function.

Standards:

- Use Markdown (.md) format as the primary documentation format.
- Use lowercase names with hyphens where practical.
- Use numbered prefixes for ordered documentation sets.
- Avoid ambiguous names such as notes.md or misc.md.

Examples:

```text
Core/
├── 00-Standards.md
├── 01-Architecture.md
└── 02-Networking.md

Services/
├── pihole.md
├── prometheus.md
└── transmission.md
```

### Infrastructure Documentation

Infrastructure documentation describes the physical and logical foundation of OnyxNet.

Infrastructure documentation should include:

- Physical hardware
- Virtualization platforms
- Network architecture
- Storage systems
- Cluster organization
- Dependencies between infrastructure components

Infrastructure documentation should describe the current design and intended purpose, not act as a change history.

### Service Documentation

Service documentation describes individual services deployed within OnyxNet.

Each service document should include:

- Purpose
- Location
- Deployment method
- Dependencies
- Network requirements
- Storage requirements
- Configuration references
- Backup and recovery information
- Validation steps

Service documentation should provide enough information to operate and recover the service without relying on undocumented knowledge.

### Ansible Documentation

Ansible documentation defines how automation is organized and maintained.

Documentation should include:

- Repository structure
- Inventory organization
- Playbook purpose
- Role ownership
- Variable usage
- Deployment expectations

Automation should remain the source of truth for managed configuration whenever practical.

### Docker Documentation

Docker documentation defines standards for containerized workloads.

Documentation should include:

- Compose deployment location
- Container purpose
- Images used
- Network requirements
- Persistent storage requirements
- Configuration references

Docker deployments should use standardized locations and be reproducible through documented configuration.

### Change Documentation

Changes affecting infrastructure, services, automation, or security configuration should be documented to preserve operational history.

Change documentation should include:

- Date of change
- System or service affected
- Description of change
- Reason for change
- Validation performed
- Follow-up actions or known impacts

Major architectural decisions should be documented separately through decision records.

---

## 9. Validation Standards

Validation ensures that infrastructure changes, service deployments, and configuration updates achieve the intended result.

All changes should include appropriate validation steps based on the scope and impact of the change.

### General Validation Requirements

Validation should confirm:

- The expected configuration was applied.
- The service or system is functioning as intended.
- Monitoring systems reflect the expected state.
- No unexpected failures were introduced.

### Infrastructure Validation

Infrastructure changes should validate:

- Host availability
- Network connectivity
- Required services
- Resource availability
- Cluster health

Examples:

- Proxmox node status
- Network reachability
- Storage availability
- Hardware health checks


### Ansible Validation

Ansible deployments should verify:

- Playbook completion without unexpected failures.
- Expected configuration state.
- Required services are enabled and running.
- Handlers completed successfully.

Where practical, roles should include automated validation tasks.

Examples:

- Confirming a service binary exists.
- Verifying configuration files are deployed.
- Checking service status.

### Docker Validation

Docker deployments should verify:

- Containers are running.
- Required ports are available.
- Persistent storage is mounted correctly.
- Application health checks pass where available.

Examples:

```bash
docker compose ps
```
```bash
docker logs <container>
```

### Monitoring Validation

Services that provide metrics or monitoring data should validate:

- Exporters are reachable.
- Metrics are being collected.
- Dashboards reflect expected data.
- Failed targets are investigated.

Monitoring should be considered part of validation for production services.

### Recovery Validation

Critical services should have documented recovery validation steps.

Recovery validation should confirm:

- Service availability
- Data integrity
- Dependent services are functioning
- Monitoring has returned to normal state

### Validation Completion

A change should not be considered complete until validation confirms the expected outcome.

Failed validation should result in:

- Investigation
- Correction
- Rollback where necessary
- Documentation updates if the expected state changed

---

## 10. Future Expansion

OnyxNet standards should support future growth while maintaining consistency, reliability, and operational clarity.

Future additions to the infrastructure should follow existing standards for naming, networking, automation, documentation, security, and validation.

### Expansion Considerations

Future infrastructure additions may include:

- Additional compute nodes
- Additional clusters
- New service categories
- Additional monitoring capabilities
- Expanded automation
- Improved backup and recovery systems

New technologies should be evaluated based on:

- Reliability
- Maintainability
- Security impact
- Integration with existing systems
- Operational complexity

### Standards Evolution

Infrastructure standards should evolve as OnyxNet grows.

Changes to standards should:

- Be documented.
- Preserve compatibility where practical.
- Include migration plans when required.
- Update affected documentation.

Existing systems should not be forced into unnecessary redesign unless there is a clear operational benefit.

### Long-Term Goal

The goal of OnyxNet documentation and standards is to create an infrastructure environment that is:

- Reproducible
- Understandable
- Recoverable
- Maintainable
- Expandable

Future growth should build upon established patterns rather than introduce isolated solutions.