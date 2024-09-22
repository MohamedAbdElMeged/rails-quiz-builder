FROM ruby:3.1.2-alpine

# Install dependencies

RUN apk add --no-cache \
    build-base \
    tzdata \
    gcompat \
    libxml2-dev \
    libxslt-dev \
    bash

WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local build.nokogiri --use-system-libraries
RUN bundle install
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Copy application code
COPY . .


# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]