# 🧪 Installing Ansible

## Install Ansible
1. Install Ansible
```bash
sudo apt install -y ansible git python3-pip
ansible --version
```

2. Download Repo
```bash
cd ~/potentpi4
git clone https://github.com/OnyxJeff/ansible.git
```

3. Create extra `identity` folders
```bash
mkdir ~/ansible/identity/{automation,revoked,users}
```

---

## Generate an SSH Key Pair

```bash
ssh-keygen -t ed25519 -C "ansible-automation"
```

- Explaination of flags:
  - `-t ed25519` → modern, secure key type (better than RSA)
  - `-C "ansible-automation"` → optional comment so you know which key it is
  - You'll see promtps like: `Enter file in which to save the key (/home/<USER>/.ssh/ansible-automation):`
- Input `/home/<USER>/.ssh/ansible-automation` and press `Enter` to accept the location.
- When prompted for a passphrase, you can either:
  - Enter one (more secure, but you’ll type it for every run unless you use ssh-agent)
  - Leave empty (convenient for automated playbooks) **[Recommended for my Homelab]**

### Verify your keys

```bash
ls -l ~/.ssh/ansible-automation*
```
- You should see two files:
  - ansible-automation → private key (keep secret!)
  - ansible-automation.pub → public key (what you copy to targets)

### Copy created public key to `/ansible/identity/automation/` folder
```bash
cp ~/.ssh/ansible-automation.pub ~/ansible/identity/automation/ansible.pub
```
### Copy user key on host machine to `/ansible/identity/user/` folder

This key was not created on this machine. It is the key that was exported via Termius (or other SSH client) from your Workstation PC to the device running Ansible. Change 'OnyxJeff' to the username used in the creation of this key on your Workstation PC
```bash
grep 'OnyxJeff' ~/.ssh/authorized_keys > ~/ansible/identity/users/onyxjeff.pub
```

## Install SSHPass on Control Node:

```bash
sudo apt install -y sshpass
```

## Commands using scripts

First we must make all scripts executable:
```bash
chmod +x ~/ansible/scripts/*.sh
```

### Commands
- Adds a node to hosts.ini for inspection later; adds users and automation SSH keys and disables password authentication on device
```bash 
bash ~/ansible/scripts/add-node.sh <IP Address> <ssh-username> <server-name>
```

- `update` and `upgrade` selected group(s)/node(s)
```bash
bash ~/ansible/scripts/update-all.sh <group>
```