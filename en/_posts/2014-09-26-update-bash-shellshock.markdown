---
layout: post
title: "Protect your bash from Shellshock"
categories: Instances
author: NicolasLM
---

On September 24th a critical security issue has been found in `bash`. The issue
is called
[Shellshock](https://security-tracker.debian.org/tracker/CVE-2014-6271). Under
certain circumstances, a remote attacker could execute commands on the system
using this breach. Here is what to do to safely use RunAbove systems.

New instances
-------------

Images on RunAbove has been updated with the latest security fix. Each new
instance will not be vulnerable anymore. You do not need to do anything else.

Already existing instances
--------------------------

For instances launched before September 26th it is very important to update
`bash`.

By now all distribution vendors have fixed the issue in the `bash` package. To
benefit from the fix you only need to update your system with the package
manager.

### Debian and Ubuntu

On Debian and Ubuntu you can update your system with `apt`:

    sudo apt-get update && sudo apt-get upgrade

### Fedora and CentOS

On Fedora and CentOS you can update your system with `yum`:

    sudo yum update

