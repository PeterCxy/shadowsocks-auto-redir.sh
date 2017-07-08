shadowsocks-auto-redir.sh
---

Once upon a time, I wrote a [blog post](https://typeblog.net/set-up-shadowsocks-with-iptables-and-ipset-on-archlinux/) on how to set up shadowsocks-redir on ArchLinux as a system-wide proxy with chnroute as default.

And now I want to make the whole process automatic.

__The following manual supports only distributions with systemd. ArchLinux is taken as default.__  
__This script requires ROOT permission and comes with ABSOLUTELY NO WARRANTY. Use it at your own risk.__

Installation
---

As this is no more than a simple script, I am not going to package it for any Linux distribution.

Install the dependencies first

```bash
# Execute as ROOT
pacman -S jq shadowsocks-libev ipset
```

Then clone this repo into any directory that the current user has access to. Take `$HOME` as an example.

```bash
# Execute as normal user
cd ~
git clone https://github.com/PeterCxy/shadowsocks-auto-redir.sh
cd shadowsocks-auto-redir.sh
```

Link itself to `/opt` and install the systemd unit

```bash
# Execute as ROOT
./install-systemd.sh link # for systemd
./install-openrc.sh link # for openrc
```

Configuration
---

Now, put your Shadowsocks configuration file into `/etc/shadowsocks/` (__Please use a plain IP address for the server address, not a domain__), for example, `/etc/shadowsocks/config.json`, and then run

```bash
# Execute as ROOT
systemctl start shadowsocks-auto-redir@config
```

After the unit get started properly, all the TCP traffic from your system will go through the Shadowsocks proxy.

In addition, this script supports some exta fields (under `ss_redir_options`) in the configuration JSON file.

```json
  "ss_redir_options": {
    "bypass_ips": [
      ...
    ],
    "bypass_preset": "chnroute",
    "ota": true
  }
```

`bypass_ips`: A list of extra IPs to which traffic should not go through Shadowsocks proxy (by default, the server IP and the internal IP addresses are excluded from the proxy)
`bypass_preset`: Include a predefined set of IPs to which traffic should not go through Shadowsocks proxy (currently only `chnroute` available which excludes all Chinese Mainland IPs)
`ota`: Enable One-Time Authentication or not.

__NOTE: This script does nothing to resolve DNS poisoning. If your network is subject to DNS poisoning, an anti-poisoning DNS server should be used or set up.__

Updating
---

Switch to the directory of this project

```bash
# Execute as normal user
git pull
sudo ./install-systemd.sh update # for systemd
sudo ./install-openrc.sh update # for openrc
```

Uninstallation
---

Stop all the relavent systemd services before uninstallation.

Switch to the directory of this project

```bash
# Execute as ROOT
./install-systemd.sh unlink # for systemd
./install-openrc.sh unlink # for openrc
```
