#!/usr/bin/env bash

set -xe

install_stuff_ubuntu() {
  apt-get -y install auditd
}

add_the_rules() {
  cat /tmp/auditd.rules >> /etc/audit/rules.d/audit.rules
  rm /tmp/auditd.rules
}

restart_services() {
  case "${BASTION_OS}" in
    Amazon)
      /usr/sbin/service auditd restart
      ;;
    CentOS|SUSE)
      /sbin/service auditd restart
      ;;
    Ubuntu)
      service auditd restart
      ;;
  esac
}

case "${BASTION_OS}" in
    Ubuntu)
      install_stuff_ubuntu
      ;;
esac

service_name="chronicled"

if systemctl is-active --quiet "$service_name.service" ; then
  echo "$service_name running"
else
  add_the_rules
  restart_services
fi

