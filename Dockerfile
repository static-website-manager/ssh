FROM ubuntu:14.04
RUN apt-get update -qq && apt-get install -y build-essential cmake git libpq-dev openssh-server ruby ruby-dev

RUN gem install 'pg'
RUN gem install 'sequel'

RUN mkdir /var/run/sshd

COPY sshd_config /etc/ssh/sshd_config
COPY authorized_keys.rb /etc/ssh/authorized_keys.rb
COPY authorized_actions.rb /etc/ssh/authorized_actions.rb

RUN chmod +x /etc/ssh/authorized_keys.rb
RUN chmod +x /etc/ssh/authorized_actions.rb
