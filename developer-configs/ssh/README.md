# SSH Config

## Deployment Service SSH Config

This directory contains an SSH config file with `Host` entries for all of our
bastions in different regions, which is intended to serve as a canonical config
that will be updated over time. To use it, add a line _at the top_ of your
`~/.ssh/config` file referencing the ssh config file in this repo:

> `Include ~/path/to/deployment-service-config/developer-configs/ssh/bastion_v3`

This will allow you to pull updates to this repo and have them take effect
automatically without needing to update your ~/.ssh/config file.

## SECEDGE SSH Config

You will also need to set up the
[SECEDGE SSH
config](https://bitbucket.oci.oraclecorp.com/projects/secedge/repos/ssh_configs/browse)
as well. To do so, clone that repo then add a second line to the top of your
`~/.ssh/config` file including the SSH config from that repo as well (as
explained in the README of that repo):

> `Include ~/path/to/ssh_configs/config`

### A Note For Mac zsh Users:

The version of zsh that ships with current macOS is too old to support
tab-completing ssh config `Host` entries from files referenced via `Include`
directives. There is a workaround explained below, but it may not be worth doing
(see caveat below).

If you want to be able to tab complete the bastion hostnames when sshing, you'll
need to install a newer zsh via `brew install zsh` and update your user's login
shell to /usr/local/bin/zsh (right-click on your user in Users & Groups
preferences and choose Advanced Options to get to the screen where you set your
shell, then it will take effect next time you open a new terminal window).

**Caveat:** Unfortunately if you also have an Include directive for the SECEDGE SSH Config,
the tab completion gets really slow.
