FROM ruby:2.7.4

RUN apt-get update \
    && apt-get install -y curl apt-transport-https wget \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y nodejs yarn chromium-driver
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile Gemfile.lock package.json yarn.lock /myapp/
RUN gem install bundler
RUN bundle install
COPY . /myapp
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]