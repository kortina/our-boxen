class people::kortina::mac {
    $home = "/Users/${::boxen_user}"


# Terminal

# could not get this part working with property_list_key
    $window_settings = file("/opt/boxen/repo/Termina_Window_Settings.plist")
    exec { "set terminal prefs" :

	command => "defaults write com.apple.Terminal \"Window Settings\" '${window_settings}'",
	user => $boxen_user
	
    }
# somehow permissions in this dirrectory would get out of whack when running boxen, so ensure correct ownership
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

# install dotfiles
$dotfiles_dir = "/opt/boxen/repo/files/${::boxen_user}/dotfiles"


# TODO: probably should re-add this part
# repository { $dotfiles_dir:
#   source => "${::github_user}/dotfiles"
# }

exec { "install dotfiles":
  cwd      => $dotfiles_dir,
  command  => "./script/bootstrap",
  provider => shell,
  user => $boxen_user
  # creates  => "${home}/.zshrc",
  # require  => Repository[$dotfiles_dir]
}

}


