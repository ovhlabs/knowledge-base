---
layout: post
title:  "How to deploy Dokku on RunAbove?"
categories: Instances
author: NicolasLM
lang: en
---

[Dokku](https://github.com/progrium/dokku) is a small yet powerful tool that provides a self-hosted Platform as a Service (PaaS).
Basically Dokku lets you focus on your code. Deployment in different environments is as easy as "git push". RunAbove makes using Dokku even easier by providing a ready to use image.

# Requirements:

To use Dokku on RunAbove, you need an SSH key, that's all.

# Installation:

The only thing you need to do to install and configure Dokku is to [launch an instance](/kb/en/instances/how-to-create-a-compute-instance-in-few-seconds.html) using the Dokku image. If you provide an SSH key to your instance it will automatically be integrated to Dokku so you can push projects without bothering with adding keys to Git.

# Pushing your first app:

Let's try your fresh Dokku with a small python web application based on the awesome [Flask](http://flask.pocoo.org/) framework. Just clone the Github repository on your computer:

```bash
git clone https://github.com/runabove/python-dokku-sample
cd python-dokku-sample
```

Get the IP of your instance from the manager and set a remote repository pointing to your Dokku instance:

```bash
git remote add dokku dokku@<ip-of-your-instance>:python-dokku-sample
```
Now push the code to Dokku:

```bash
git push dokku master
```

You will see that Dokku is preparing a new environment, taking care of installing all the dependencies of the code for you. As it is a Python project dependencies are fetched using _pip_, for a Node.js application it would to the same with _npm_ or _gem_ for Ruby.

When the deployment is done you will see a message containing the link to access the app:

```bash
    -----> Deploying python-dokku-sample ...
    -----> Application deployed:
            http://<ip-of-your-instance>:49153
```

If you have a __security group__ that filters incoming connections you have to allow the port used by Dokku. Follow the link with your browser and you will see the '__Hello Dokku!__' showing that the application is running.

# Going further with Dokku:

## Adding SSH keys:

If when you push your code, Dokku asks for a password it means that your SSH key is not registered by Dokku. In this case, you must add the key you want to use. You can add as many keys as you want, allowing teams to use the same Dokku platform for their projects.

To register an SSH key use:
```bash
cat ~/.ssh/id_rsa.pub | ssh admin@<ip-of-your-instance> sudo sshcommand acl-add dokku <name-of-the-key>
```

## Command line tool:

Dokku can be managed from your computer with the command line. A convenient way of doing that is using SSH with a bash alias:

```bash
alias dokku="ssh -t dokku@<ip-of-your-instance>"
```

Now you can execute dokku commands, for example to get all the options:
```bash
dokku help
```

## Deploying apps to a subdomain:

By default Dokku provides access to your application using a specific port. You can change this setting to deploy your projects in your own domain, for example __app.domain.tld__.

For that you have to add an A records to your domain zone. Go to the manager of your DNS zone and create a wildcard entry: *.domain.tld pointing to the IP of your instance.

You now have to tell dokku to use the virtual host feature by adding a config file. SSH to your instance as the user _admin_ and create the file "_/root/dokku/VHOST_" containing your domain name:

```bash
ssh admin@<ip-of-your-instance>
sudo vim /home/dokku/VHOST
```

In the text editor just write the name of your domain, for example "domain.tld". Save it and you are done.

Next time you will push a project it will be accessible at <project>.domain.tld, for example:
```bash
git push dokku master
    -----> Deploying python-dokku-sample ...
    -----> Application deployed:
            http://python-dokku-sample.domain.tld
```

__Tip:__ if you name your remote repository as a [fully qualified domain name](http://en.wikipedia.org/wiki/Fully_qualified_domain_name), you can deploy to the root of your domain, or even multiple domains. Just be sure to point your DNS to the domains you use. For example:

```bash
git remote add dokku dokku@<ip-of-your-instance>:mydomain.tld
git push dokku master
     -----> Application deployed:
            http://mydomain.tld
```

You now have a fully featured PaaS in your instance with Dokku. As Dokku continues to evolve, be sure to check their [Github page](https://github.com/progrium/dokku) to enjoy all the new functionalities.
