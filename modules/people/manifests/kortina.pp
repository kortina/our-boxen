class people::kortina {

    # libs

    include ctags
    include java
    include vim
    include git
    include hub

    # applications

    include alfred
    include bash
    include bash::completion
    include caffeine
    include dropbox
    include spotify
    include virtualbox
    include vlc

    # install homebrew packages
    package { 'tmux': ensure => present } # seems to be failing right now. just `brew install tmux` in a shell and this should pass

    package { 'python': ensure => present } # seems to be some sort of problem where this does not install pip in mavericks
    
    exec { 'easy_install pip': command => 'easy_install pip' }

    # This seems to be insanely slow. Not sure why. May be better installing this via web.
    # package { 'Boot2Docker':
    #   provider => 'pkgdmg',
    #   source   => 'https://github.com/boot2docker/osx-installer/releases/download/v1.2.0/Boot2Docker-1.2.0.pkg',
    #   unless   => 'which boot2docker'
    # }

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
    # OS X
    ########################################

    # $gdrive_screenshots_dir =  "${home}/Google-Drive/_screenshots" 

    # exec { "change screenshot folder location to Google-Drive" :
    #     command => "test -d ${gdrive_screenshots_dir} && defaults write com.apple.screencapture location ${gdrive_screenshots_dir} && killall SystemUIServer",
    #     unless => "defaults read com.apple.menuextra.screencapture location | grep -q '${gdrive_screenshots_dir}"
    # }

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
