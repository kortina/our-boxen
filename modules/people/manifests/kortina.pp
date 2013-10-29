class people::kortina {
    # applications
    include airfoil
    include alfred
    include bash
    include bash::completion
    include caffeine
    include cyberduck
    include divvy
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

    # custom
    include people::kortina::mac

}
