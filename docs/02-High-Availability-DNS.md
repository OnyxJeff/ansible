# High Availability DNS

| Item | Value |
|------|-------|
| **Status** | Production |
| **Managed By** | Ansible |
| **Last Validated** | 2026-07-25 |
| **Primary Role** | `keepalived` |
| **Dependencies** | Docker, Prometheus, Node Exporter, Pi-hole |



## Validation Checklist

- [ ] Ansible playbook completed successfully
- [ ] Pi-hole resolves DNS
- [ ] Keepalived service is active
- [ ] VIP is assigned correctly
- [ ] Prometheus target is UP
- [ ] Node Exporter metrics are available
- [ ] Keepalived metrics are present
- [ ] Grafana dashboard is healthy