This repository contains tutorials of [RunAbove Knowledge
base](https://community.runabove.com/kb).

# How to write a how-to guide and get $100 in RunAbove credit?

Help the community benefit from all of RunAbove’s power, and earn RunAbove
credit to take your own project even further! The process is quick, easy, and
we’re open to your suggestions.

## Who can do this?

Anyone can submit a how-to guide for review via GitHub. If you don’t already
have a GitHub account, you can create one for free.

## What can you do?

Diversity is at our core and we’re open to a huge range of subjects. Keep in
mind that that RunAbove users are devs or devops, so a how-to guide on making
Runabove products work seamlessly with popular technologies/stacks/services
would be a perfect angle.

## How can you do it?

Simply fork the runabove/knowledge-base project on our GitHub page. Create a
new page under [/en/_posts](en/_posts) and using markdown to write your how-to
guide. Please refer to the metadata in existing guides so that you add adequate
metadata at the beginning of your guide. Feel free to create a folder for your
images in [/images](images).

The existing guide categories are development, network, and object storage. If
you don’t think your guide falls under any of these, don’t hesitate to suggest
a new one - we’ll take it into consideration.

When you’re done, launch a pull request for your fork. Once we’ve received your
guide, we will review it against our criteria, and either accept it or reject
it. You’ll hear back from us as soon as possible, we may ask you to do some
modifications to your guide. If we merge your fork, we’ll give you a voucher
for $100 for you to use with RunAbove!

Please note that we may not accept your how-to guide if it doesn’t fit our
review criteria. Here is a list of some of the main points we’ll take into
account:

 * Your guide is written in English.
 * Any prerequisites for carrying out the steps in the guide are listed in your
 guide’s intro.
 * Any usage you encourage is completely legal and respects good practices and
 security standards.
 * Content is your own and doesn’t include any copyrighted content (including
 images). Your proposal should be exclusively published on our website.

Please also keep in mind that we’re mainly interested in how-to guides on
open-source tools and integration with popular tier technologies.

If you want to talk to us about your fork, please get in touch with us on our
IRC channel: `#runabove` on Freenode.

# Quick start your new tutorial:

## Create your tutorial

Fork runabove/knowledge-base repository and get the content on your machine.

```
git clone https://github.com/your_github_username/knowledge-base.git
```

Add a file inside __posts__ directory with this template:

```markdown
---
layout: post
title:  "My first tutorial"
categories: Instances
author: your_github_username
lang: en
---

# Here you can add your tutorial

With markdown syntax.
```

## Test your tutorial

To deploy tutorials on runabove, we use a ruby tool called
[Jekyll](http://jekyllrb.com/). You can find more informations about Jekyll
installation inside the [official
documentation](http://jekyllrb.com/docs/installation/). The easiest way to get it up and running is:

```bash
curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3 --autolibs=fail
curl https://raw.githubusercontent.com/creationix/nvm/v0.25.1/install.sh | bash
nvm install 0.10
nvm use 0.10
source ~/.bashrc
gem install bundler
bundle
```

Inside root directory of the project, you can run this command to generate the
website and see your guide:

```bash
bundle exec jekyll build
```

You website is now inside `_site` directory.

You can also run this command to have jekyll serve your static pages :

```bash
bundle exec jekyll serve
```

When your tutorial is ready, create a pull request on GitHub. Then we will
review your tutorial. If that's your first tutorial, to benefit of your
RunAbove credit, we need to get
[TOS](https://community.runabove.com/kb/en/contracts_tutorials_EN-GB.pdf)
signed by your hand (picture of the document). After, we merge it and the
website is automatically updated.

# Got a great idea? Fork us now!
