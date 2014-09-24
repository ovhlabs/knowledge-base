---
layout: post
title:  "Manage a multi-region OpenStack infrastructure with Foreman"
categories: Instances
author: NicolasLM
lang: en
---

Foreman is a tool that a allows to manage an infrastructure of servers easily.
It is compatible with OpenStack so it can automatize the deployment of RunAbove
instances.

Foreman uses a Ruby library called [fog](https://github.com/fog/fog) to be
compatible with many providers. This library does the abstraction layer between
Foreman and OpenStack.

In RunAbove we have an OpenStack cloud with two regions, `SBG-1` and `BHS-1`.
This is handled correctly in fog, but Foreman does not allow to select the
proper OpenStack region. Thus it fails with the message:

    Multiple regions available choose one of these 'SBG-1,BHS-1'

Until the Foreman developers update their software to use the multi-region 
feature of fog, a quick patch can be made, allowing to set one region. Just 
patch the file
[openstack.rb](https://github.com/theforeman/foreman/blob/d21103bcf13b5981601be88330ce73dbe4a1ed77/app/models/compute_resources/foreman/model/openstack.rb#L104)
line 104, and add:

    :openstack_region   => 'SBG-1'   ,

This will tell fog to only work on the `SBG-1` region. Restart Foreman and you
will be able to work on a multi-region OpenStack cloud.
