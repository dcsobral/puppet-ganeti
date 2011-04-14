class ganeti::xen::clocksource {
    case $virtual {
        # Node
        "xen0": {
            include ganeti::ntp
        }

        # Instance
        'xenu': {
            common::line { 'sysctl-clocksource':  
                ensure => present,
                file   => '/etc/sysctl.conf',
                line   => 'xen.independent_wallclock=0',
                notify => Exec['/sbin/sysctl -p # ganeti clocksource'],
            }

            exec { '/sbin/sysctl -p # ganeti clocksource':
                refreshonly => true,
            }
        }
    }
}

# vim: set ts=4 sw=4 et:
