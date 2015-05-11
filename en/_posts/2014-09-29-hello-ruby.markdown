---
layout: post
title: "Running your Ruby application on Sailabove"
categories: docker
tags: guide, getting-started, ruby
lang: en
author: yadutaf
---

[Ruby](https://www.ruby-lang.org/en/) is a dynamic, object-oriented and expressive language. When Heroku (the PaaS pioneer) debuted, Ruby was so popular among startupers that it only specifically targeted Ruby applications!

Ruby comes with a [huge library of "Gems"](https://rubygems.org/) installable using ``gem install``.

But Ruby would have probably never gotten so famous without [Ruby on Rails](http://rubyonrails.org/), a full featured web framework that inspired many others. And that's not the only one. There is also [Sinatra](http://www.sinatrarb.com/), a lightweight micro-framework. Ruby is also the foundation of [Gitlab](https://about.gitlab.com/), the leading OpenSource GitHub alternative.

Before diving in, make sure to read the [Getting Started](getting-started-with-sailabove-docker.html) guide.

1. Write an awesome application
===============================

Let's do something unique. Like, say, an "Hello Docker" application. In a hurry? You can already see the result on Sailabove: http://hello-ruby.demo.app.sailabove.io/hello/Docker-Fan

For this example, we'll use the popular [Sinatra](http://www.sinatrarb.com/) micro-framework.

Here is the full ``server.rb`` source code:

```ruby
require 'sinatra'
require 'cgi'

set :port, 80
set :bind, '0.0.0.0'

get '/hello/:name' do |name|
    name = CGI::escapeHTML(name)
    "Hello <b>#{name}</b>!"
end
```

We now need to declare our dependencies using a ``Gemfile`` file. In this case, only ``Sinatra``:

```
source "https://rubygems.org"
gem 'sinatra', '1.4.5'
```

2. Dockerize it
===============

Ruby is a Docker first class citizen. It has its [own dedicated official image](https://registry.hub.docker.com/u/library/ruby/) supporting Ruby 1.9, 2.0 and 2.1. For this example, we'll use Ruby 2.1.

Here is our ``Dockerfile``:

```
FROM ruby:2.1-onbuild
EXPOSE 80
CMD ["ruby", "server.rb"]
```

It first instructs Docker to get Ruby ``2.1`` base image with automatic build support (``-onbuild``). To use Ruby 1.9 base image instead, you may choose to use ``FROM ruby:1.9-onbuild`` for instance.

We then declare the ``PORT`` our application will listen on. In our case, standard HTTP port.

Lastly, it instructs Docker the ``CMD`` to launch our application.

OK, let's build and test it locally:

```bash
touch Gemfile.lock
docker build -t hello-ruby .
docker run -it --publish 8080:80 --rm -t hello-ruby
```

Check if all works fine, visit http://localhost:8080/hello/Docker-Fan. You should see something like "Hello Docker-Fan!".

It works on your dev machine. It will work on production.

3. Go live!
===========

Let's go: ``tag`` our application so that Docker knows where to prod it:

```bash
# docker tag <local app name>  sailabove.io/<user name>/<app name>
docker tag hello-ruby sailabove.io/demo/hello-ruby
```

Push your application on Sailabove's *private* Docker registry:

```bash
# docker push <previously created tag>
docker push sailabove.io/demo/hello-ruby
```

Launch it using previously installed ``sail`` command line and instruct Sailabove to run it with unprivileged user ``nobody`` for increased security. Please note that, even when running as regular unprivileged user, your application can freely listen on *any* port, ``80`` in this case.

```bash
# sail services add <user name>/<app name> <service name>
sail services add demo/hello-ruby hello-ruby
```

Eager to see the result? Wait a few seconds. It is now running live on http://hello-ruby.demo.app.sailabove.io/hello/Docker-Fan. This is ``http://<service name>.<user name>.app.sailabove.io``.

Enjoy!

Getting help
============

- Get started: [Getting started quide][8]
- Documentation: [Reference documentation][9], [Guides][10]
- Join OVH Docker mailing list: [docker-subscribe@ml.ovh.net][5]
- Visit our Community: [https://community.runabove.com/][6]
- Drop us an e-mail: [sailabove@ovh.net][1]
- Create your account: [Sailabove.com][7]

  [1]: mailto:sailabove@ovh.net
  [5]: mailto:docker-subscribe@ml.ovh.net
  [6]: https://community.runabove.com/
  [7]: https://sailabove.com/
  [8]: /kb/en/docker/getting-started-with-sailabove-docker.html
  [9]: /kb/en/docker/documentation
  [10]: /kb/en/docker/
