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
    include vim

    # install homebrew packages
    package { 'tmux': ensure => present } # seems to be failing right now. just `brew install tmux` in a shell and this should pass

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

    exec { 'pip install git+git://github.com/Lokaltog/powerline':
        command => 'pip install git+git://github.com/Lokaltog/powerline'
    }

    exec { 'pip install nose-run-line-number':
        command => 'pip install nose-run-line-number'
    }

    $home = "/Users/${::boxen_user}"

    ########################################
    # Terminal
    ########################################
    exec { "show date in menubar" :
        command => "defaults write com.apple.menuextra.clock DateFormat 'EEE MMM d  h:mm a' && killall SystemUIServer",
        unless => "defaults read com.apple.menuextra.clock DateFormat | grep -q MMM"
    }
    ########################################
    # install dotbuild #TODO: this will eventually be a pip install
    ########################################
    $dotbuild = "/opt/boxen/dotbuild"

    repository { $dotbuild:
        source => "kortina/dotbuild"
    }
    exec { "install dotbuild":
        cwd      => $dotbuild,
        command  => "pip install -e .",
        provider => shell,
        user => $boxen_user,
        require  => Repository[$dotbuild]
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
        command  => "dotbuild --no-confirm",
        provider => shell,
        user => $boxen_user,
        require  => [
			Repository[$dotfiles],
			Repository[$dotbuild],
			Exec["install dotbuild"]
		    ]
    }

    ########################################
    # install bakpak
    ########################################
    $bakpak = "/opt/boxen/bakpak"

    repository { $bakpak:
        source => "kortina/bakpak"
    }

    ########################################
    # various symlinks
    ########################################
     file { "/Applications/Screen\\ Sharing.app":
        ensure => 'link',
        target => "/System/Library/CoreServices/Screen\\ Sharing.app",
    }

}
