# shellcheck shell=bash
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

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::perl::home::symlink()
#
#  Environment:	 P6_DFZ_SRC_DIR P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::perl::home::symlink() {

  p6_dir_mk "$P6_DFZ_SRC_DIR/tokuhirom/plenv/plugins"
  p6_file_symlink "$P6_DFZ_SRC_DIR/tokuhirom/Perl-Build" "$P6_DFZ_SRC_DIR/tokuhirom/plenv/plugins/perl-build"

  p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-perl/share/.cpanm" ".cpanm"

  p6_return_void
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

  p6_dir_run "$P6_DFZ_SRC_DIR/tokuhirom/plenv" p6_git_p6_pull
  p6_dir_run "$P6_DFZ_SRC_DIR/tokuhirom/Perl-Build" p6_git_p6_pull 

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

  p6_return_void
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

  p6df::modules::perl::prompt::init

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::perl::prompt::init()
#
#>
######################################################################
p6df::modules::perl::prompt::init() {

  p6df::core::prompt::line::add "p6_lang_prompt_info"
  p6df::core::prompt::line::add "p6_lang_envs_prompt_info"
  p6df::core::prompt::lang::line::add pl

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::perl::plenv::init(dir)
#
#  Args:
#	dir -
#
#  Environment:	 HAS_PLENV P6_DFZ_LANGS_DISABLE PLENV_ROOT
#>
######################################################################
p6df::modules::perl::plenv::init() {
  local dir="$1"

  local PLENV_ROOT=$dir/tokuhirom/plenv
  if p6_string_blank "$P6_DFZ_LANGS_DISABLE" && p6_file_executable "$PLENV_ROOT/bin/plenv"; then
    p6_env_export PLENV_ROOT "$PLENV_ROOT"
    p6_env_export HAS_PLENV 1
    p6_path_if $PLENV_ROOT/bin
    eval "$(plenv init - zsh)"
  fi

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6_pl_env_prompt_info()
#
#  Returns:
#	str - str
#
#  Environment:	 PERL5LIB PLENV_ROOT
#>
######################################################################
p6_pl_env_prompt_info() {

  local str="plenv_root:\t  $PLENV_ROOT
perl5lib:\t  $PERL5LIB"

   p6_return_str "$str"
}
