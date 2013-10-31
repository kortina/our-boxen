class people::kortina {
    # applications
    include airfoil
    include alfred
    include bash
    include bash::completion
    include caffeine
    include cyberduck
    # include divvy # I install from app store instead
    include dropbox
    include onepassword
    include skype
    include spotify
    include virtualbox
    include vlc

    # libs
    include ctags
    include java
    include vim

    # install homebrew packages
    package { 'python': # and pip
        ensure => present
    }
    package { 'jsl':
        ensure => present
    }

    # pip modules
    exec { 'pip install flake8':
        command => 'pip install flake8'
    }
    exec { 'pip install ipython':
        command => 'pip install ipython'
    }

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
    exec { "show date in menubar" :
	command => "defaults write com.apple.menuextra.clock DateFormat 'EEE MMM d  h:mm a' && killall SystemUIServer",
        unless => "defaults read com.apple.menuextra.clock DateFormat | grep -q MMM"
    }
    exec { "show battery percent in menubar" :
	command => "defaults write com.apple.menuextra.battery ShowPercent -string \"YES\" && killall SystemUIServer",
        unless => "defaults read com.apple.menuextra.battery ShowPercent | grep -q YES"
    }
    exec { "set Divvy prefs" :
	command => "defaults write com.mizage.Divvy '{ enableAcceleration = 1; globalHotkey =     { keyCode = 49; modifiers = 768; }; shortcuts = <62706c69 73743030 d4010203 04050831 32542474 6f705824 6f626a65 63747358 24766572 73696f6e 59246172 63686976 6572d106 0754726f 6f748001 a6090a10 26272d55 246e756c 6cd20b0c 0d0f5a4e 532e6f62 6a656374 73562463 6c617373 a10e8002 8005dd11 12131415 16171819 1a1b1c0c 1d1e1e1f 1e202122 23221d21 255f1012 73656c65 6374696f 6e456e64 436f6c75 6d6e5f10 1173656c 65637469 6f6e5374 61727452 6f775d6b 6579436f 6d626f46 6c616773 5c6b6579 436f6d62 6f436f64 655f1014 73656c65 6374696f 6e537461 7274436f 6c756d6e 57656e61 626c6564 5b73697a 65436f6c 756d6e73 5a737562 64697669 64656457 6e616d65 4b657956 676c6f62 616c5f10 0f73656c 65637469 6f6e456e 64526f77 5873697a 65526f77 73100510 00102e09 10060880 03088004 516dd228 292a2b58 24636c61 73736573 5a24636c 6173736e 616d65a2 2b2c5853 686f7274 63757458 4e534f62 6a656374 d228292e 2fa32f30 2c5e4e53 4d757461 626c6541 72726179 574e5341 72726179 12000186 a05f100f 4e534b65 79656441 72636869 76657200 08001100 16001f00 28003200 35003a00 3c004300 49004e00 59006000 62006400 66008100 9600aa00 b800c500 dc00e400 f000fb01 03010a01 1c012501 27012901 2b012c01 2e012f01 31013201 34013601 3b014401 4f015201 5b016401 69016d01 7c018401 89000000 00000002 01000000 00000000 33000000 00000000 00000000 00000001 9b>; useGlobalHotkey = 1; }'",
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
