FROM ruby:1.9-onbuild

MAINTAINER RunAbove <contact@runabove.com>

EXPOSE 4000

RUN apt-get update && apt-get -yy install nodejs
RUN jekyll build

CMD jekyll serve --host 0.0.0.0 --port 4000
