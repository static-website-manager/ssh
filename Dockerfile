FROM ubuntu:14.04
RUN apt-get update -qq && apt-get install -y build-essential cmake git libpq-dev openssh-server ruby ruby-dev

RUN gem install 'pg'
RUN gem install 'sequel'

RUN mkdir /var/run/sshd

RUN addgroup --system --gid 1448 git
RUN adduser --disabled-password --gecos '' --uid 1448 --ingroup git git

COPY sshd_config /etc/ssh/sshd_config
COPY public_keys.rb /etc/ssh/public_keys.rb
COPY allowed_actions.rb /home/git/allowed_actions.rb

RUN chmod +x /etc/ssh/public_keys.rb
RUN chmod +x /home/git/allowed_actions.rb
RUN chown git /home/git/allowed_actions.rb
