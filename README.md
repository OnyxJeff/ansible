## 🧪 Installing Ansible

- Install Ansible
```bash
sudo apt install -y ansible git python3-pip
ansible --version
```

- Generate an SSH Key Pair

```bash
ssh-keygen -t ed25519 -C "ansible-automation"
```
  - Explaination of flags:
    - `-t ed25519` → modern, secure key type (better than RSA)
    - `-C "ansible-automation"` → optional comment so you know which key it is
    - You'll see promtps like:
    `Enter file in which to save the key (/home/<USER>/.ssh/ansible-automation):`
  - Press **Enter** to accept the default location.
  - When prompted for a passphrase, you can either:
    - Enter one (more secure, but you’ll type it for every run unless you use `ssh-agent`)
    - Leave empty (convenient for automated playbooks)

- Verify your keys
```bash
ls -l ~/.ssh/ansible-automation*
```

  - You should see two files:
    - `ansible-automation` → private key (keep secret!)
    - `ansible-automation.pub` → public key (what you copy to targets)

- Copy created public key to `/ansible/identity/automation/` folder
```bash
cp ~/.ssh/ansible-automation.pub ~/pp4-valkyrie/ansible/identity/automation/
```

- Copy user key on host machine to `/ansible/identity/user/` folder
```bash
grep 'OnyxJeff' ~/.ssh/authorized_keys > ~/pp4-valkyrie/ansible/identity/user/onyxjeff.pub
```

- Install SSHPass on Control Node:
```bash
sudo apt install -y sshpass
```

- Copy the public key to a target host
  Example for a Pi or Linux VM:
  ```bash
  ssh-copy-id pi@<target-host-ip>
  ```
  - Replace `pi` with the username on the target.
  - Replace `<target-host-ip>` with the IP address.
  If SSH is default port 22, this works. If custom port:
  ```bash
  ssh-copy-id -p 2222 pi@<target-host-ip>
  ```

- Test passwordless SSH
```bash
ssh pi@<target-host-ip>
```
  - You should log in without a password prompt.
  - If it asks for a password, something went wrong—check `~/.ssh/authorized_keys` on the target.

- Optional: Agent Forwarding (Handy for Ansible)
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/ansible-automation
```
This lets Ansible use the key automatically