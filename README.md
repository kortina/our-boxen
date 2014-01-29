# Our Boxen Fork

This is a fork of https://github.com/boxen/our-boxen .  If you plan on using a fork of my boxen repo, you should be sure to checkout the source README here:

* https://github.com/boxen/our-boxen/blob/master/README.md

NB: I removed the following modules that ship by default with the `boxen/our-boxen` repo (from `Puppetfile` and `site.pp`):

`autoconf`, `dnsmasq`, `gcc`, `nginx`, `Node.js 0.4`, `Node.js 0.6`, `Node.js 0.8`, `Ruby 1.8.7`, `Ruby 1.9.2`, `Ruby 1.9.3` 

Most of my other customizations are in:

* https://github.com/kortina/our-boxen/blob/master/modules/people/manifests/kortina.pp

This is still a work in progress.  Todos are in:

* https://github.com/kortina/our-boxen/blob/master/TODO.md


## Getting Started

To give you a brief overview, we're going to:

* Install dependencies (basically Xcode)
* Bootstrap a boxen for your self/team/org/company
* Then convert your local copy of that boxen to the post-bootstrapped version

There are a few potential conflicts to keep in mind.
Boxen does its best not to get in the way of a dirty system,
but you should check into the following before attempting to install your
boxen on any machine (we do some checks before every Boxen run to try
and detect most of these and tell you anyway):

* Boxen __requires__ at least the Xcode Command Line Tools installed.
* Boxen __will not__ work with an existing rvm install.
* Boxen __may not__ play nice with a GitHub username that includes dash(-)
* Boxen __may not__ play nice with an existing rbenv install.
* Boxen __may not__ play nice with an existing chruby install.
* Boxen __may not__ play nice with an existing homebrew install.
* Boxen __may not__ play nice with an existing nvm install.
* Boxen __recommends__ installing the full Xcode.

### Dependencies

NB: One of the first things you may want to do is grab your ssh private key and `ssh-add` it.

**Install the Xcode Command Lines Tools and/or full Xcode.**
This will grant you the most predictable behavior in building apps like
MacVim.

How do you do it?

#### OS X 10.9 (Mavericks)

If you are using [`b26abd0` of boxen-web](https://github.com/boxen/boxen-web/commit/b26abd0d681129eba0b5f46ed43110d873d8fdc2)
or newer, it will be automatically installed as part of Boxen.
Otherwise, follow instructions below.

#### OS X < 10.9

1. Install Xcode from the Mac App Store.
1. Open Xcode.
1. Open the Preferences window (`Cmd-,`).
1. Go to the Downloads tab.
1. Install the Command Line Tools.

### Bootstrapping

=======
See for details on how to bootstrap for first time: https://github.com/boxen/our-boxen/blob/master/README.md#bootstrapping

Once you have your own boxen fork, you might do something more like:

    xcode-select --install # install xcode cmd line tools
    sudo mkdir -p /opt/boxen
    sudo chown ${USER}:staff /opt/boxen
    git clone git@github.com:kortina/our-boxen.git /opt/boxen/repo
    
It should run successfully, and should tell you to source a shell script
in your environment.
For users without a bash or zsh config or a `~/.profile` file,
Boxen will create a shim for you that will work correctly.
If you do have a `~/.bashrc` or `~/.zshrc`, your shell will not use
`~/.profile` so you'll need to add a line like so at _the end of your config_:

``` sh
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
```

Once your shell is ready, open a new tab/window in your Terminal
and you should be able to successfully run `boxen --env`.
If that runs cleanly, you're in good shape.


## Binary packages

We support binary packaging for everything in Homebrew, rbenv, and nvm.
See `config/boxen.rb` for the environment variables to define.

## Sharing Boxen Modules

If you've got a Boxen module you'd like to be grouped under the Boxen org,
(so it can easily be found by others), please file an issue on this
repository with a link to your module.
We'll review the code briefly, and if things look pretty all right,
we'll fork it under the Boxen org and give you read+write access to our
fork.
You'll still be the maintainer, you'll still own the issues and PRs.
It'll just be listed under the boxen org so folks can find it more easily.

##upgrading boxen
See [FAQ-Upgrading](https://github.com/boxen/our-boxen/blob/master/docs/faq.md#q-how-do-you-upgrade-your-boxen-from-the-public-our-boxen).

## Integrating with Github Enterprise

If you're using a Github Enterprise instance rather than github.com,
you will need to set the `BOXEN_GITHUB_ENTERPRISE_URL` and
`BOXEN_REPO_URL_TEMPLATE` variables in your
[Boxen config](config/boxen.rb).

## Halp!

See [FAQ](https://github.com/boxen/our-boxen/blob/master/docs/faq.md).

Use Issues or #boxen on irc.freenode.net.
