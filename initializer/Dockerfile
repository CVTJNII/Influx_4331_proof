# Run off Debian Jessie for Ruby 2
FROM debian:jessie
MAINTAINER Tom Noonan II (thomas.noonan@corvisa.com)

RUN apt-get update && apt-get install -y ruby ruby-dev

#RUN gem install influxdb
# Load a custom gem containing:
#  Fix show policies syntax: d929e386d4aa6203489eae47ad3e96b9b7c064cc - https://github.com/influxdb/influxdb-ruby/pull/109
#  Add alter_retention_policy(): 14595de93f1433f342ef4d03a09597df48f11feb - https://github.com/influxdb/influxdb-ruby/pull/114
# Built off https://github.com/CVTJNII/influxdb-ruby
RUN gem install specific_install
RUN gem specific_install -l https://github.com/CVTJNII/gemshare/raw/master/influxdb-0.2.3.gem

RUN useradd -r -s /bin/false initializer

COPY files/initializer /initializer
USER initializer
CMD /initializer/initializer.rb
