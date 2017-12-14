## Custom Dockerfile
FROM consol/ubuntu-xfce-vnc
MAINTAINER Archit Gupta "archit.gupta@incedoinc.com"
USER 0
# Make TEST USER
RUN useradd testuser --shell /bin/bash --create-home \
  && usermod -a -G sudo testuser \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'testuser:nopassword' | chpasswd
RUN mkdir /data && chown -R testuser:testuser /data
RUN find /data -type d -print0 | xargs -0 chmod 775
# Install Firefox 44
RUN wget https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/44.0.2/linux-x86_64/en-US/firefox-44.0.2.tar.bz2
RUN tar -xjvf firefox-*.tar.bz2
RUN rm -rf /opt/firefox*
RUN mv firefox /opt/firefox
RUN ln -sf /opt/firefox/firefox /usr/bin/firefox
## Install a gedit
RUN apt-get install -y gedit
RUN mkdir /robot_automation
copy brat_integration_branch/ /robot_automation
copy run.sh /
# INSTALL Basic packages like xvfb unzip etc
RUN apt-get update -y
RUN apt-get install -y wget xvfb unzip curl vim jq net-tools iputils-ping openssh-server openssh-client
# INSTALL python firefox and other tools
RUN apt-get install -y --no-install-recommends --allow-unauthenticated \
    python python-pip python-setuptools python-wheel build-essential \
    libssl-dev libffi-dev python-dev 
RUN apt-get install python-wxgtk3.0 -y
RUN  apt-get install dpkg -y
RUN apt-get autoremove -y &&\
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists
# Upgrade pip and other framework packages
RUN pip install --upgrade pip &&\
    pip install configparser && \
    pip install -r /robot_automation/requirement.txt
RUN pip install -U https://github.com/HelioGuilherme66/RIDE/archive/v2.0a2.tar.gz
RUN ln -s /pycharm-community/bin/pycharm.sh /usr/bin/pycharm
copy pycharm-community/ /pycharm-community
# Add python in pythonpath
RUN chown -R testuser:testuser /robot_automation
RUN chown -R testuser:testuser /pycharm-community
RUN chown -R testuser:testuser /usr/local/bin/
RUN chown -R testuser:testuser /usr/bin/
ENV PYTHONPATH "${PYTHONPATH}:/robot_automation/lib:/robot_automation/utils"
RUN echo $PYTHONPATH
RUN chown -R testuser:testuser /headless
RUN chmod 777 /headless
RUN chmod u+x /headless
#USER 0
