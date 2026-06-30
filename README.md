# 🧪 Installing Ansible

## Install Ansible
```bash
sudo apt install -y ansible git python3-pip
ansible --version
```

---

## Commands using scripts

First we must make all scripts executable:
```bash
chmod +x ~/potentpi4/ansible/scripts/*.sh
```

### Commands
- Adds a node to hosts.ini for inspection later; adds users and automation SSH keys and disables password authentication on device
```bash 
bash ~/potentpi4/ansible/scripts/add-node.sh <IP Address> <ssh-username> <server-name>
```

- `Update` and `upgrade` selected node(s)
```bash
bash ~/potentpi4/ansible/scripts/update-all.sh <group>
```