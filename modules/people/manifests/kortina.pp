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

    $home = "/Users/${::boxen_user}"

    ########################################
    # Terminal
    ########################################
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
