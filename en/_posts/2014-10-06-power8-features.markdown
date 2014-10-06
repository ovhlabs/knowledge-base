---
layout: post
title: "How to use Power8 features"
categories: Instances
author: NicolasLM
---

Power8 is a new generation of processors designed to improve performances of 
parallelized computations. This guide will explain how to customize the 
features of the processor on the go.

How Power8 processors are different?
------------------------------------

Power8 allows you to changes the specifications of the system on the go. You 
can adapt the characteristics of the CPU to your needs.

Customize the features
----------------------

Running the command `ppc64_cpu` as root you can manage the Power8 features.

### Threads

If you application use a reduced number of instructions or do not do expensive 
IO, you can benefit from disabling threads. For example, set 8 threads per 
core:

    sudo ppc64_cpu --smt=8

Completely disable threads:

    sudo ppc64_cpu --smt=off

### Cores

Our Power8 processor has 22 cores, as you can check with:

    sudo ppc64_cpu --cores-present
       - Number of cores present = 22

You can disable cores on the go:

    sudo ppc64_cpu --cores-on=8
    sudo ppc64_cpu --cores-on
       - Number of cores online = 8

Do not forget to buy a second monitor dedicated to htop, otherwise you will not 
see any process:

![](https://storage.bhs-1.runabove.io/v1/AUTH_3eca649cc7f44d91b67131374db4afb3/public/coreos_screenshot1.jpg)

![Power8 htop](/kb/images/2014-10-06-power8/htop.png)
