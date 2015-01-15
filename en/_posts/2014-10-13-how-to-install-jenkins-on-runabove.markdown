---
layout: post
title: How to install Jenkins on RunAbove?
categories: instances
tags: guide
author: DrOfAwesomeness
lang: en
---
[Jenkins](http://jenkins-ci.org) is an open-source continuous integration server written in Java. It's a popular solution that is used by [Numerous companies](https://wiki.jenkins-ci.org/pages/viewpage.action?pageId=58001258) including Github and Dell.

1. Installing Jenkins
=====================

Installing Jenkins on RunAbove is a fairly simple process. This tutorial assumes you are using Ubuntu 14.04 on your RunAbove instance.
First, add the key for the Jenkins APT repository to your keychain:

```
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
```

Next, append the Jenkins APT repository to your sources.list file:

```
echo deb http://pkg.jenkins-ci.org/debian binary/ | sudo tee -a /etc/apt/sources.list
```

Then, update your package lists and install the jenkins package:

```
sudo apt-get update -y && sudo apt-get install -y jenkins
```

Finally, you'll need to allow port 8080 through the RunAbove firewall. To do this, go to OpenStack Horizon, select the region your instace is in under "Managing Region", go to "Access & Security" and add a rule to the default security group allowing Ingress port 8080.

Congratulations! Your Jenkins server is now avaliable at `http://your-instance-ip:8080` (replace `your-instance-ip` with the IP of your instance). Note that your instance is currently publicly-accessible. For information on configuring security for your Jenkins server, see the [Securing Jenkins](https://wiki.jenkins-ci.org/display/JENKINS/Securing+Jenkins) page on the [Jenkins Wiki](https://wiki.jenkins-ci.org/display/JENKINS/Home).

2. Configuring a simple project
===========================
So, now that you have Jenkins set up, it's time to configure your first Job. For this tutorial we'll be configuring Jenkins to build the `master`	 branch of [a Github repository](https://github.com/DrOfAwesomeness/hello-jenkins). 

First, you'll need to install the Git plugin for Jenkins. To do this, go to `Manage Jenkins->Manage plugins`, click the "Available" tab, find the Git plugin in the list, select it, and click "Download and install without restart." 

Next, you'll need to install any tools required to build your repository. The repository I'm building in this example is a Node.js repository, so I need to install Node.js, build-essential (for building native extensions), and git. I'm using the NodeSource repository here, as the version of Node.js in the Ubuntu repository is often outdated.

```bash
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y nodejs build-essential git
```
Once any tools that will be necessary to build your project have been installed, you can configure the repository in Jenkins. On the sidebar, select "New Item". In the menu that appears, enter a name and project type (in my example, a Freestyle project.)

The next page is the Job configuration page, which is where you will configure how your Job is built. Under "Source Code Management", select Git. When the repository URL box appears, enter the HTTPS clone URL of your Github repository. Scroll down to "Build Triggers" and select "Poll SCM". In the "Schedule" box that appears, you can define how often you'd like to poll Github for changes in [cron format](https://en.wikipedia.org/wiki/Cron#Format). Here's a schedule that will cause Jenkins to poll for changes every five minutes:
`H/5 * * * *`

Now that SCM polling is configured, it's time to tell Jenkins how to build your project. In the case of my [hello-jenkins](https://github.com/DrOfAwesomeness/hello-jenkins) repository, I need it to install the dependencies with NPM, start the project, run the tests, and stop it again. To accomplish this, I go to "Build", click on "Add build step", and select "Execute Shell". In the box that appears, I enter the shell commands to build my repository:

```bash
npm install
npm start
npm test
npm stop
```

When you've configured your project's build the way you like it, click the Save button.

That's it! Your Jenkins server is now configured to poll Github every five minutes and build any changes it finds. If there's anything you don't understand after reading this tutorial, the [Jenkins Wiki](https://wiki.jenkins-ci.org/display/JENKINS/Home) is a valuable resource.

### Bonus: Automatically building when a push to Github is made
If you don't want to wait five minutes after you push to Github for your repository to be built, Github provides a way to notify your Jenkins instance of pushes. To set this up, you must be a collaborator on the Github repository you are building (feel free to fork [hello-jenkins](https://github.com/DrOfAwesomeness/hello-jenkins) if you want a repository to test this out with). To link your Github repository to your Jenkins instance, open your repository settings on Github, go to "Webhooks & Services", click on "Add service", and select the "Jenkins (Git plugin)" from the list. In the "Jenkins url" box, enter `http://your-instance-ip:8080/`, replacing `your-instance-ip` as necessary. Make sure the "Active" checkbox is checked and click "Add service". Now Github will trigger a Jenkins build whenever you push a change.
