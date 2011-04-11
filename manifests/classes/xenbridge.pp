class ganeti::xenbridge {
    exec { "/usr/bin/perl -pi -e 's/(allow-hotplug|auto) eth0/auto xen-br0/' /etc/network/interfaces":
        unless => "/bin/grep -q 'auto xen-br0' /etc/network/interfaces",
        alias => 'perl auto',
    }

    exec { "/usr/bin/perl -pi -e 's/iface eth0/iface xen-br0/' /etc/network/interfaces":
        unless => "/bin/grep -q 'iface xen-br0' /etc/network/interfaces",
        require => Exec['perl auto'],
        notify => Service['networking'],
    }

    service { 'networking':
        hasrestart => true,
        status => '/bin/true',
    }

    file { '/etc/network/interfaces':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => 644,
    }

    exec { '/bin/echo "        bridge_ports eth0" >> /etc/network/interfaces':
        unless => '/bin/grep -q "bridge_ports eth0" /etc/network/interfaces',
        notify => Service['networking'],
        before => Service['networking'],
    }

    exec { '/bin/echo "        bridge_fd 9" >> /etc/network/interfaces':
        unless => '/bin/grep -q "bridge_fd 9" /etc/network/interfaces',
        notify => Service['networking'],
        before => Service['networking'],
    }

    exec { '/bin/echo "        bridge_hello 2" >> /etc/network/interfaces':
        unless => '/bin/grep -q "bridge_hello 2" /etc/network/interfaces',
        notify => Service['networking'],
        before => Service['networking'],
    }

    exec { '/bin/echo "        bridge_maxage 12" >> /etc/network/interfaces':
        unless => '/bin/grep -q "bridge_maxage 12" /etc/network/interfaces',
        notify => Service['networking'],
        before => Service['networking'],
    }

    exec { '/bin/echo "        bridge_stp off" >> /etc/network/interfaces':
        unless => '/bin/grep -q "bridge_stp off" /etc/network/interfaces',
        notify => Service['networking'],
        before => Service['networking'],
    }
}

# vim: set ts=4 sw=4 et:
