class ganeti {
    package { [
            'firmware-qlogic',
            'firmware-bnx2',
            'ganeti2',
        ]:
        ensure => installed,
    }

    $hostline = inline_template('<%= ipaddress %>	<%= fqdn %> <%= hostname %>')

    exec { "/usr/bin/perl -pi -e 's/^$ipaddress.*/$hostline/' /etc/hosts":
        unless => "/bin/grep -q '$hostline' /etc/hosts",
    }

    file { '/etc/hostname':
        content => "$fqdn\n",
        notify  => Service['hostname.sh'],
    }

    file { '/etc/lvm/lvm.conf':
        source  => 'puppet:///ganeti/lvm/lvm.conf',
    }

    service { 'hostname.sh': }

    include ganeti::xen

    # Só configura drbd e xenbridge se o kernel for xen
    if $virtual == 'xen0'{
        include ganeti::drbd
        include ganeti::xenbridge
    }
}

# vim: set ts=4 sw=4 et:
