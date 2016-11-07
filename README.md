This repository contains tutorials of [RunAbove Knowledge
base](https://community.runabove.com/kb).

# How to write a how-to guide?

Simply fork the runabove/knowledge-base project on our GitHub page. Create a
new page under [/en/_posts](en/_posts) and using markdown to write your how-to
guide. Please refer to the metadata in existing guides so that you add adequate
metadata at the beginning of your guide. Feel free to create a folder for your
images in [/images](images).

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

### With Docker (recommended)

The easiest way to test how your guide renders on RunAbove website is to build
and run the Docker container.

```bash
docker build --tag runabove-kb .
docker run --rm -ti -p 4000:4000 runabove-kb
```

You can now point your browser to http://localhost:4000/kb/ and see how it
looks.

### Installing Jekyll

To deploy tutorials on runabove, we use a ruby tool called
[Jekyll](http://jekyllrb.com/). You can find more informations about Jekyll
installation inside the [official
documentation](http://jekyllrb.com/docs/installation/). Get it up and running:

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

When you’re done, open a pull request for your fork. We'll review it as soon
as possible!

# Got a great idea? Fork us now!

