class ganeti::xen {
    # Versão do kernel xen correspondente à versão atual
    $kernelxen = $virtual ? {
        /^xen/  => $kernelrelease,
        default => regsubst($kernelrelease,'-amd64$','-xen-amd64'),
    }
        
    package { "xen-linux-system-$kernelxen":
        ensure => installed,
    }

    package { "linux-image-$kernelxen":
        ensure => installed,
        notify => Exec['/sbin/shutdown -r 5 min &'],
    }

    file { '/etc/xen/xend-config.sxp':
        source  => 'puppet:///ganeti/xen/xend-config.sxp',
        require => Package["xen-linux-system-$kernelxen"],
        before  => Exec['/sbin/shutdown -r 5 min &'],
        owner   => 'root',
        group   => 'root',
        mode    => 644,
    }

    # Altera o grub para limitar CPU e Memória
    exec { "/usr/bin/perl -pi -e 's/^# xenhopt=.*$/# xenhopt=dom0_mem=1024M/' /boot/grub/menu.lst":
        unless => '/bin/grep -q "# xenhopt=dom0_mem=1024M" /boot/grub/menu.lst',
        notify => Exec['/usr/sbin/update-grub'],
        before => Exec['/sbin/shutdown -r 5 min &'],
    }

    exec { "/usr/bin/perl -pi -e 's/^# xenkopt=.*$/# xenkopt=console=tty0 maxcpus=1/' /boot/grub/menu.lst":
        unless => '/bin/grep -q "# xenkopt=console=tty0 maxcpus=1" /boot/grub/menu.lst',
        notify => Exec['/usr/sbin/update-grub'],
        before => Exec['/sbin/shutdown -r 5 min &'],
    }

    exec { '/usr/sbin/update-grub':
        refreshonly => true,
        before      => Exec['/sbin/shutdown -r 5 min &'],
    }

    # Links simbólicos
    file { '/boot/vmlinuz-2.6-xenU':
        ensure  => "vmlinuz-$kernelxen",
        require => Package["xen-linux-system-$kernelxen"],
        before  => Exec['/sbin/shutdown -r 5 min &'],
    }

    file { '/boot/initrd.img-2.6-xenU':
        ensure  => "initrd.img-$kernelxen",
        require => Package["xen-linux-system-$kernelxen"],
        before  => Exec['/sbin/shutdown -r 5 min &'],
    }

    # Shutdown se o kernel tiver sido trocado
    exec { '/sbin/shutdown -r 5 min &':
        refreshonly => true,
        require     => Package["xen-linux-system-$kernelxen"],
    }
}

# vim: set ts=4 sw=4 et:
