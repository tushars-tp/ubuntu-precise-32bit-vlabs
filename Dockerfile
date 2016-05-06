#  Base image from tushars-tp/ubuntu-precise-32bit
FROM ubuntu-precise-32bit

# File Author / Maintainer
MAINTAINER Tushar Sakhadeo

# delete all the apt list files since they're big and get stale quickly
RUN rm -rf /var/lib/apt/lists/*
# this forces "apt-get update" in dependent images, which is also good

# enable the universe
RUN sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list

RUN echo "# WANdisco Open Source Repo" > /etc/apt/sources.list.d/WANdisco.list
RUN echo "deb http://opensource.wandisco.com/ubuntu precise svn18" >> /etc/apt/sources.list.d/WANdisco.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E9F0E9223BBF077A

RUN apt-get update -y && apt-get -y upgrade

# Install dev packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install gcc g++ make flex byacc bison python2.7 exuberant-ctags cscope build-essential libxml2 libxml2-dev libstdc++6 subversion git --no-install-recommends

# Cleanup install cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# expose ssh port
EXPOSE 22

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
