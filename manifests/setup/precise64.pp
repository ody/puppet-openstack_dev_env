import 'hosts.pp'

#
# This puppet manifest is already applied first to do some environment specific things
#

apt::source { 'openstack_folsom':
  location          => "http://ubuntu-cloud.archive.canonical.com/ubuntu",
  release           => "precise-updates/folsom",
  repos             => "main",
  required_packages => 'ubuntu-cloud-keyring',
}

#
# configure apt to use my squid proxy
# I highly recommend that anyone doing development on
# OpenStack set up a proxy to cache packages.
#
class { 'apt':
  proxy_host => '172.16.0.1',
  proxy_port => '3128',
}

# an apt-get update is usally required to ensure that
# we get the latest version of the openstack packages
exec { '/usr/bin/apt-get update':
  require     => Class['apt'],
  refreshonly => true,
  subscribe   => [Class['apt'], Apt::Source["openstack_folsom"]],
  logoutput   => true,
}


package { 'vim': ensure => present }

