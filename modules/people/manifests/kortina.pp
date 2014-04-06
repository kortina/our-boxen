class people::kortina {
    # NB: you should also add the corresponding source for these includes in
    # `Puppetfile`

    # applications
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
    include tmux
    include vim

    # install homebrew packages
    package { 'python': ensure => present } # seems to be some sort of problem where this does not install pip in mavericks
    exec { 'easy_install pip': command => 'easy_install pip' }

    # package { 'jsl':
        # ensure => present
    # }

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
    # think this might be causing probs.  Removing for now.
    # $window_settings = file("/opt/boxen/repo/Termina_Window_Settings.plist")
    # exec { "set terminal prefs" :
      # command => "defaults write com.apple.Terminal \"Window Settings\" '${window_settings}'",
      # user => $boxen_user
    # }
    # ensure correct ownership (was seeing root ownership after some boxen runs)
    # exec { "ensure ~/Library/Preferences ownership" :
      # command => "chown -fR ${::boxen_user}:staff /Users/${::boxen_user}/Library/Preferences",
      # user => "root"
    # }
    exec { "Terminal - Default Window Settings" :
      command => "defaults write com.apple.Terminal 'Default Window Settings' 'ir_black_lion'",
      unless  => "defaults read com.apple.Terminal 'Default Window Settings' | grep -q ir_black_lion"
    }
    exec { "Terminal - Startup Window Settings" :
      command => "defaults write com.apple.Terminal 'Startup Window Settings' 'ir_black_lion'",
      unless  => "defaults read com.apple.Terminal 'Startup Window Settings' | grep -q ir_black_lion"
    }
    exec { "show date in menubar" :
	command => "defaults write com.apple.menuextra.clock DateFormat 'EEE MMM d  h:mm a' && killall SystemUIServer",
        unless => "defaults read com.apple.menuextra.clock DateFormat | grep -q MMM"
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
     file { "/Applications/Screen\\ Sharing.app":
        ensure => 'link',
        target => "/System/Library/CoreServices/Screen\\ Sharing.app",
    }

}
