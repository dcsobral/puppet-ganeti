class ganeti::hooks {

    # Non-templated files
    file { '/etc/ganeti/instance-debootstrap':
            ensure  => directory,
            owner   => 'root',
            group   => 'root',
            #mode   => 644, # Cannot apply mode, or it will change ALL files
            source  => 'puppet:///ganeti/ganeti/instance-debootstrap',
            recurse => true,
            replace => true,
            force   => true,
            purge   => true,
            ignore  => [ '.git', '.swp', ],
            notify  => Exec['remover cache ganeti'],
    }

    # Purge cache files after modify hooks
    exec { '/bin/rm -f /var/cache/ganeti-instance-debootstrap/cache-squeeze-amd64.tar':
        refreshonly => true,
        alias       => 'remover cache ganeti',
    }


    # Templated files
    # Require dnssearch and nameservers
    file { '/etc/ganeti/instance-debootstrap/hooks/03_network':
        ensure  => present,
        content => template('ganeti/03_network.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => 755,
        notify  => Exec['remover cache ganeti'],
    }

    # Require zabbixserver
    file { '/etc/ganeti/instance-debootstrap/hooks/06_zabbix':
        ensure  => present,
        content => template('ganeti/06_zabbix.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => 755,
        notify  => Exec['remover cache ganeti'],
    }

    # Generate users and passwords for administrators based on the file used by the users module

    $administrators = extlookup("administrators_accounts")

    file { '/etc/ganeti/instance-debootstrap/hooks/users':
        ensure  => present,
        content => template('ganeti/users.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => 644,
        notify  => Exec['remover cache ganeti'],
    }

    file { '/etc/ganeti/instance-debootstrap/hooks/passwords':
        ensure  => present,
        content => template('ganeti/passwords.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => 644,
        notify  => Exec['remover cache ganeti'],
    }
}

# vim: set ts=4 sw=4 et:
