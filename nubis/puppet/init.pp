# Main entry for puppet
#

# Here we are simply importing a custom application puppet file.
# Typically you will include things like Apache and other puppet modules
# which are included in the base image.
import 'skel.pp'
import 'apache.pp'
import 'storage.pp'

package { 'epel-release':
  ensure => present,
}->
yumrepo { 'epel':
  enabled => true,
}->
package {
  [
    'ImageMagick-perl',
    'graphviz',
    'mod24_perl',
    'openssl-devel',
    'patchutils',
    'perl',
    'perl-devel',
    'perl-version',
    'perl-autodie',
    'perl-App-cpanminus',
    'perl-Authen-SASL',
    'perl-Cache-Memcached',
    'perl-Capture-Tiny',
    'perl-Carp',
    'perl-CPAN',
    'perl-Crypt-CBC',
    'perl-Crypt-DES',
    'perl-Crypt-DES_EDE3',
    'perl-DBD-MySQL',
    'perl-DBI',
    'perl-Data-Dumper',
    'perl-DateTime',
    'perl-Digest-SHA',
    'perl-Email-MIME',
    'perl-Email-MIME-Attachment-Stripper',
    'perl-Email-MIME-Encodings',
    'perl-Email-Reply',
    'perl-Email-Send',
    'perl-Encode-Detect',
    'perl-Exception-Class',
    'perl-File-Find-Rule',
    'perl-GD',
    'perl-GD-Barcode',
    'perl-GDGraph',
    'perl-GDTextUtil',
    'perl-HTML-Parser',
    'perl-HTML-Scrubber',
    'perl-HTML-Tree',
    'perl-HTTP-Tiny',
    'perl-IO-stringy',
    'perl-JSON-XS',
    'perl-LDAP',
    'perl-libwww-perl',
    'perl-Linux-Pid',
    'perl-LWP-Protocol-https',
    'perl-MIME-tools',
    'perl-Module-Pluggable',
    'perl-Mozilla-CA',
    'perl-Regexp-Common',
    'perl-SOAP-Lite',
    'perl-Sub-Uplevel',
    'perl-Sys-Syslog',
    'perl-Template-Toolkit',
    'perl-Text-Diff',
    'perl-Test-Deep',
    'perl-Test-Differences',
    'perl-Test-Exception',
    'perl-Test-Most',
    'perl-Test-NoWarnings',
    'perl-Test-Simple',
    'perl-Test-Taint',
    'perl-Test-Warn',
    'perl-Tie-IxHash',
    'perl-TimeDate',
    'perl-Time-Duration',
    'perl-URI',
    'perl-XML-Simple',
    'perl-XML-Twig',
    'perl-YAML-Syck',
  ]:
    ensure => present,
}

file { "/var/www/bugzilla/answers.txt":
  ensure => present,
  source => "puppet:///nubis/files/answers.txt",
}

file { "/usr/local/bin/bugzilla-install-dependencies":
  ensure => present,
  source => "puppet:///nubis/files/install-dependencies",
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
}

file { "/usr/local/bin/bugzilla-update":
  ensure => present,
  source => "puppet:///nubis/files/update",
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
}

file { "/etc/confd":
  ensure  => directory,
  recurse => true,
  purge => false,
  owner => 'root',
  group => 'root',
  source => "puppet:///nubis/files/confd",
}
