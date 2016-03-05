# ssh_wrapper
SSH wrapper to restrict to specific set of commands

authorized_keys template:

    from="MY_IP",command="/MY_PATH/ssh_wrapper.sh",no-agent-forwarding,no-X11-forwarding,no-port-forwarding,no-pty ssh-rsa MY_SSH_PUBLIC_KEY
