---
layout: post
title:  "How to do data science in R on Ubuntu 14.04 with runabove"
categories: Instances
author: rickyking
lang: en
---

`R` is a popular programming language for data scientist. It's more friendly than python (no object-oriented programming required) and more academic friendly. Most statistician use R as the first language.

Here I will demostrate how to build up an R toolbox including:

- Newest version of [R](http://cran.r-project.org): the 14.04 Ubuntu repository only has a 3.0.x version R
- [RStudio Server](http://www.rstudio.com/products/rstudio/download-server/): the web-based GUI
- [Shiny Server](http://www.rstudio.com/products/shiny/shiny-server/): an interactive & reactive R web-application
- [opencpu framework](https://www.opencpu.org): a REST-ful api service for R

## Install R

By default, you can do `sudo apt-get install r-base` to install R from the ubuntu repository. But unfornately, you will now be able to install the newest version of R.

So we will install the newest R with R cran official repository.

1. Open the apt-list file `/etc/apt/sources.list` with your favorite editor. Here I use `nano`: `sudo nano /etc/apt/sources.list`
2. Add the following line at the top of the file: `deb http://cran.rstudio.com/bin/linux/ubuntu trusty/`. You can replace `cran.rstudio.com` with your favorite [mirror site](), and `trusty` by your Ubuntu release.
    - `trusty` for 14.04
    - `utopic` for 14.10
    - `precise` for 12.04
    - `lucid` for 10.04
3. Next execute the following command to install `r-base`

```bash
sudo apt-get update
sudo apt-get install r-base
```

Once done, type `R` to begin the programming.

## Install opencpu & RStudio Server

Next I will illustrate how to install openCPU & RStudio.

OpenCPU provides a RESTful api interface for R. With a JavaScript library offered by openCPU, the development between R and Web seems easier.

Let’s begin to install.

```bash
# setup the official repository
sudo add-apt-repository ppa:opencpu/opencpu-1.4
# update & install
sudo apt-get update
sudo apt-get install opencpu
```

You also have an option to install a cache server which will cache the result for a while and no need to regenerate the result. The cache server is available via `sudo apt-get install opencpu-cache`.

Once installed, you can direct your browser to `http://your-ip-address/ocpu` to access the opencpu.

You can use the following command to control opencpu:

```bash
sudo service opencpu start
sudo service opencpu stop
sudo service opencpu restart
```
For test, you can `curl -L http://your-ip-address/ocpu/library/` to see all the libraries installed.

The repository of opencpu provide as well the RStudio.

RStudio is the most popular GUI for R programmer. The web based version grant you access to the R previously installed in the server with your browser.

A simple command is enough to install RStudio: `sudo apt-get install rstudio-server`.

Once done, use the following command to start:

```bash
sudo rstudio-server start
```

Then the RStudio Server is available via `http://your-ip-address/rstudio/`.

The default user of `runAbove` is `admin` and password-less. You should create a new user or create a password for admin in order to login.

## Shiny Server

Shiny is a web framework for R. It provides HTML-less, JavaScript-less and CSS-less web-application design.

In order to install shiny, you need in first place install `shiny` library:

```bash
sudo su - \
-c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""
```

Once done, install `gdebi-core`.

```bash
sudo apt-get install gdebi-core
```

Get `shiny-server` deb package and install via `gdebi` command:

```bash
wget http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.3.0.403-amd64.deb
sudo gdebi shiny-server-1.3.0.403-amd64.deb
```

Once done, you can start the server by:

```bash
sudo start shiny-server
```
