#cloud-config
users:
  - name: "${VM_USER}"
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - "${SSH_KEY}"
