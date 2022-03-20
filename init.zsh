######################################################################
#<
#
# Function: p6df::modules::perl::deps()
#
#>
######################################################################
p6df::modules::perl::deps() {
  ModuleDeps=(
    p6m7g8-dotfiles/p6perl
    tokuhirom/plenv
    tokuhirom/Perl-Build
  )
}

######################################################################
#<
#
# Function: p6df::modules::perl::vscodes()
#
#>
######################################################################
p6df::modules::perl::vscodes() {

  # perl
  cpanm --force --notest Perl::LanguageServer
  code --install-extension richterger.perl
  code --install-extension sfodje.perltidy
}

######################################################################
#<
#
# Function: p6df::modules::perl::home::symlink()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::perl::home::symlink() {

  p6_dir_mk "$P6_DFZ_SRC_DIR/tokuhirom/plenv/plugins"
  p6_file_symlink "$P6_DFZ_SRC_DIR/tokuhirom/Perl-Build" "$P6_DFZ_SRC_DIR/tokuhirom/plenv/plugins/perl-build"
}

######################################################################
#<
#
# Function: p6df::modules::perl::langs()
#
#  Environment:	 JSON LWP MIME P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::perl::langs() {

  (
    cd $P6_DFZ_SRC_DIR/tokuhirom/plenv
    git pull
  )
  (
    cd $P6_DFZ_SRC_DIR/tokuhirom/Perl-Build
    git pull
  )

  # nuke the old one
  local previous=$(plenv install -l | grep "5\.[0-9][02468]\." | head -2 | sed -e 's, *,,g')
  plenv uninstall -f $previous

  # get the shiny one
  local latest=$(plenv install -l | grep "5\.[0-9][02468]\." | head -1 | sed -e 's, *,,g')
  plenv install $latest
  plenv global $latest
  plenv rehash

  plenv install-cpanm
  plenv rehash

  cpanm --self-upgrade

  cpanm --force --notest Template \
    LWP::UserAgent \
    JSON \
    MIME::Lite \
    Text::Replace \
    Perl::Tidy

  plenv rehash
}

######################################################################
#<
#
# Function: p6df::modules::perl::init()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::perl::init() {

  p6df::modules::perl::plenv::init "$P6_DFZ_SRC_DIR"
}

######################################################################
#<
#
# Function: p6df::modules::perl::plenv::init(dir)
#
#  Args:
#	dir -
#
#  Environment:	 DISABLE_ENVS HAS_PLENV PLENV_ROOT
#>
######################################################################
p6df::modules::perl::plenv::init() {
  local dir="$1"

  [ -n "$DISABLE_ENVS" ] && return

  PLENV_ROOT=$dir/tokuhirom/plenv

  if [ -x $PLENV_ROOT/bin/plenv ]; then
    export PLENV_ROOT
    export HAS_PLENV=1

    p6df::util::path_if $PLENV_ROOT/bin
    eval "$(p6_run_code plenv init - zsh)"
  fi
}

######################################################################
#<
#
# Function: p6df::modules::perl::plenv::prompt::line()
#
#  Depends:	 p6_echo
#  Environment:	 PERL5LIB PLENV_ROOT
#>
######################################################################
p6df::modules::perl::plenv::prompt::line() {

  p6_echo "plenv:\t  plenv_root=$PLENV_ROOT
plenv:\t  perl5lib=$PERL5LIB"
}

######################################################################
#<
#
# Function: p6df::modules::perl::prompt::line()
#
#>
######################################################################
p6df::modules::perl::prompt::line() {

  p6_perl_prompt_info
}

######################################################################
#<
#
# Function: p6_perl_prompt_info()
#
#  Depends:	 p6_lang
#>
######################################################################
p6_perl_prompt_info() {

  echo -n "pl:\t  "
  p6_lang_version "pl"
}
