class ganeti::ntp {
    package { 'ntp': ensure => present, }

    service { 'ntp':
        hasrestart => true,
        require    => Package['ntp'],
    }

    file { '/etc/ntp.conf':
        ensure  => present,
        source  => [
                "puppet:///files/ganeti/host/ntp.conf.$fqdn",
                "puppet:///files/ganeti/host/ntp.conf.$hostname",
                "puppet:///files/ganeti/domain/ntp.conf.$domain",
                "puppet:///files/ganeti/env/ntp.conf.$environment",
                'puppet:///files/ganeti/ntp.conf',
                'puppet:///ganeti/ntp.conf',
            ],
        notify  => Service['ntp'],
        require => Package['ntp'],
    }
}

# vim: set ts=4 sw=4 et:
