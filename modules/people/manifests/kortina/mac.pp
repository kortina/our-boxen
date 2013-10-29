class people::kortina::mac {
    $home = "/Users/${::boxen_user}"

    ########################################
    # Terminal
    ########################################
    # could not get this part working with property_list_key
    $window_settings = file("/opt/boxen/repo/Termina_Window_Settings.plist")
    exec { "set terminal prefs" :
	command => "defaults write com.apple.Terminal \"Window Settings\" '${window_settings}'",
	user => $boxen_user
    }
    # ensure correct ownership (was seeing root ownership after some boxen runs)
    exec { "ensure ~/Library/Preferences ownership" :
	command => "chown -fR ${::boxen_user}:staff /Users/${::boxen_user}/Library/Preferences",
	user => "root"
    }
    property_list_key { 'Terminal - Default Window Settings':
        ensure     => present,
        path       => "${home}/Library/Preferences/com.apple.Terminal.plist",
        key        => 'Default Window Settings',
        value      => 'ir_black_lion', 
        value_type => 'string'
    }
    property_list_key { 'Terminal - Startup Window Settings':
        ensure     => present,
        path       => "${home}/Library/Preferences/com.apple.Terminal.plist",
        key        => 'Startup Window Settings',
        value      => 'ir_black_lion', 
        value_type => 'string'
    }

    ########################################
    # install dotfiles
    ########################################
    $dotfiles = "/opt/boxen/dotfiles"

    repository { $dotfiles:
        source => "kortina/dotfiles"
    }

    exec { "install dotfiles":
        cwd      => $dotfiles,
        command  => "./install.sh",
        provider => shell,
        user => $boxen_user,
        require  => Repository[$dotfiles]
    }

    ########################################
    # various symlinks
    ########################################
     file { "${home}/.ssh":
        ensure => 'link',
        target => "${home}/Dropbox/nix/ssh",
        force  => true
    }
     file { "/Applications/Screen\\ Sharing.app":
        ensure => 'link',
        target => "/System/Library/CoreServices/Screen\\ Sharing.app",
    }
}


