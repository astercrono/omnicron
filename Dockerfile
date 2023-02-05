FROM docker.io/ruby:3.2.0-bullseye AS ruby-env
RUN gem update --system && gem install bundler && gem install rake

FROM ruby-env as system-env
RUN apt update

FROM system-env as dbot-env

ARG project_dir=/app/omnicron
RUN mkdir -p $project_dir/config
RUN mkdir -p $project_dir/logs
RUN mkdir -p $project_dir/data

COPY ./src $project_dir/src/
COPY run.rb $project_dir/
COPY ./rakelib $project_dir/rakelib
COPY ./spec $project_dir/spec
COPY ./Gemfile $project_dir/
COPY ./Gemfile.lock $project_dir/
COPY ./.rspec $project_dir/
COPY ./Rakefile $project_dir/
COPY ./description $project_dir/

WORKDIR $project_dir
RUN rake build_prod