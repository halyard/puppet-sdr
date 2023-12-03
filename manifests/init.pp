# @summary Configure SDR tools
#
# @param rtl_433_version sets the tag of the rtl_433 repo to deploy
class sdr (
  String $rtl_433_version = '23.11',
) {
  $version_check = '/usr/local/bin/rtl_433 -V 2>&1 | grep version | cut -d\' \' -f3'

  package { [
      'rtl-sdr',
      'cmake',
  ]: }

  -> vcsrepo { '/opt/rtl_433':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/merbanan/rtl_433.git',
    revision => $rtl_433_version,
    notify   => Exec['cmake .. && make install'],
  }

  -> file { '/opt/rtl_433/build':
    ensure => directory,
  }

  -> exec { 'cmake .. && make install':
    path    => '/usr/bin',
    cwd     => '/opt/rtl_433/build',
    unless  => "test -f /usr/local/bin/rtl_433 && [[ \"$(${version_check})\" == '${rtl_433_version}' ]]",
    require => Package['cmake'],
  }
}
