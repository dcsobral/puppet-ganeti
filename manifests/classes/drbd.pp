class ganeti::drbd {
    include apt::debsrc_sources_list

    package { ['drbd8-source', 'drbd8-utils']:
        ensure => installed,
        #notify => Exec['/usr/bin/m-a update'],
    }

    if "$drbdmod" == "no" {
        exec { '/usr/bin/m-a update':
            #refreshonly => true,
            require => Package['drbd8-source', 'drbd8-utils'],
            notify => Exec['/usr/bin/m-a -i a-i drbd8'],
        }
    }

    exec { '/usr/bin/m-a -i a-i drbd8':
        refreshonly => true,
        returns => [0, 249],
        notify => Exec['echo modules'],
    }

    exec { '/bin/echo "drbd minor_count=128 usermode_helper=/bin/true" >> /etc/modules':
        unless => "/bin/grep -q 'drbd minor_count=128 usermode_helper=/bin/true' /etc/modules",
        refreshonly => true,
        alias => 'echo modules',
        notify => Exec['/sbin/depmod -a'],
    }

    exec { '/sbin/depmod -a':
        refreshonly => true,
        notify => Exec['modprobe drbd'],
    }

    exec { '/sbin/modprobe drbd minor_count=128 usermode_helper=/bin/true':
        refreshonly => true,
        alias => 'modprobe drbd',
    }

    file { '/etc/drbd.conf':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => 644,
        source  => 'puppet:///ganeti/drbd/drbd.conf',
        require => Package['drbd8-source', 'drbd8-utils'],
    }

    exec { "/usr/bin/perl -pi -e 's%^(\\s*)(filter.*)%\$1#\$2\\n    filter = [ \"r|/dev/cdrom|\", \"r|/dev/drbd[0-9]+|\" ]%' /etc/lvm/lvm.conf":
        unless => "/bin/grep -qE 'filter = .*drbd' /etc/lvm/lvm.conf",
        require => Package['drbd8-source', 'drbd8-utils'],
    }
}

# vim: set ts=4 sw=4 et:
