# @summary Configure SDR tools
#
# @param rtl_433_version sets the tag of the rtl_433 repo to deploy
class sdr (
  String $rtl_433_version = '21.12',
) {
  package { [
      'rtl-sdr',
      'cmake',
  ]: }

  vcsrepo { '/opt/rtl_433':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/merbanan/rtl_433.git',
    revision => $rtl_433_version,
  }

  -> file { '/opt/rtl_433/build':
    ensure => directory,
  }

  -> exec { 'cmake .. && make install':
    path     => '/usr/bin',
    cwd      => '/opt/rtl_433/build',
    unless   => '/usr/local/bin/rtl_433 -V 2>&1 | awk \'/rtl_433 version/ { print $3 }\'',
    requires => Package['cmake'],
  }
}
