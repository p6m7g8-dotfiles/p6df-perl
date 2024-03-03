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

  p6_run_dir "$P6_DFZ_SRC_DIR/tokuhirom/plenv" p6_git_p6_pull
  p6_run_dir "$P6_DFZ_SRC_DIR/tokuhirom/Perl-Build" p6_git_p6_pull

  # nuke the old one
  local previous=$(p6df::modules::perl::plenv::latest::installed)
  plenv uninstall -f $previous

  # get the shiny one
  local latest=$(p6df::modules::perl::plenv::latest)
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
# Function: p6df::modules::perl::plenv::latest()
#
#>
######################################################################
p6df::modules::perl::plenv::latest() {

  plenv install -l | p6_filter_select "5\.[0-9][02468]\." | p6_filter_first "1" | p6_filter_spaces_strip
}

######################################################################
#<
#
# Function: p6df::modules::perl::plenv::latest::installed()
#
#>
######################################################################
p6df::modules::perl::plenv::latest::installed() {

  plenv install -l | p6_filter_select "5\.[0-9][02468]\." | p6_filter_from_end "2" | p6_filter_spaces_strip
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

  p6df::core::lang::mgr::init "$P6_DFZ_SRC_DIR/tokuhirom/plenv" "pl"

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6df::modules::pl::env::prompt::info()
#
#  Returns:
#	str - str
#
#  Environment:	 PERL5LIB PLENV_ROOT
#>
######################################################################
p6df::modules::pl::env::prompt::info() {

  local str="plenv_root:\t  $PLENV_ROOT
perl5lib:\t  $PERL5LIB"

  p6_return_str "$str"
}
