FROM starefossen/ruby-node:2-8
# dependens for rails
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get clean && apt-get update -qq
RUN apt-get install -y --no-install-recommends apt-utils


RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i -e 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=ru_RU.UTF-8

ENV LANG ru_RU.UTF-8 

RUN apt-get update -qq && apt-get install -y\
  build-essential\
  ruby-dev\
  liblzma-dev

RUN mkdir Autoparking
WORKDIR /Autoparking

COPY package.json ./
COPY Gemfile ./
RUN echo '' >> ./Gemfile.lock

RUN gem install bundler
RUN bundle
ENTRYPOINT [ "/bin/bash"]