---
layout: post
title: "How to install Gitlab CE on RunAbove"
categories: Instances
author: DrOfAwesomeness
lang: en
---
[Gitlab](https://about.gitlab.com/) Community Edition is a free and open-source git repository management and code collaboration tool. It provides an issue tracker, pull request system, and repository management system.

1. Installing Gitlab
================
Installing Gitlab is a straightforward and easy process. Note that because RunAbove currently blocks outbound port 25 due to abuse, if you want your Gitlab instance to be able to send email, you'll need to install Postfix and [configure it to use another mail server as a relay](/kb/en/instances/how-to-relay-postfix-mails-via-smtp.gmail.com-on-ubuntu-14.04.html). To set up Gitlab, you'll need to download the official deb package and install it:

```bash
wget https://downloads-packages.s3.amazonaws.com/ubuntu-14.04/gitlab_7.3.2-omnibus-1_amd64.deb
sudo dpkg -i gitlab_7.3.2-omnibus-1_amd64.deb
```

Please note that the `dpkg` command above may take up to 10 minutes to complete. After `dpkg` has finished, you'll need to edit the Gitlab configuration file with `sudo -e /etc/gitlab/gitlab.rb`. In the editor, change the `external_url` line to the URL you will be using to access Gitlab, which can be the IP address of your instance if you don't have a domain name pointed at it. After you've set the `external_url`, save the file and run `sudo gitlab-ctl reconfigure`. Congratulations, you have successfully installed Gitlab CE on your RunAbove instance!

2. Configuring Users and Projects
============================
So, now that you have successfully set up Gitlab CE on your instance, you'll probably want to add some users and projects. Go ahead and browse to the IP address or domain name of your instance. You'll be greeted with a sign in screen. The default username is `root` and the default password is `5iveL!fe`. Upon signing in, you'll immediately be prompted for a new password.

After updating your password, you'll be presented with your user dashboard. From here you can create a new project or group. If you want to make a new project, simply click on the New Project button, enter the project name, choose the project visibility, and hit the Create Project button. If you want to add more users to your Gitlab instance, you can do so by clicking the Admin Area icon (a large gear and two smaller gears) in the upper-right corner of your screen, and clicking on "New User". Please note that if you did not install Postfix and [configure it to use another mail server as a relay](/kb/en/instances/how-to-relay-postfix-mails-via-smtp.gmail.com-on-ubuntu-14.04.html), you will need to edit the user after creation to set the password.

Congratulations, you now have a working Gitlab CE instance! There are no limits to the number of projects you can create in Gitlab CE besides the limitations of the disk space on your RunAbove instance. If you want to learn more about Gitlab CE, be sure to check out the [documentation](http://doc.gitlab.com/ce/).
