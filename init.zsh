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

  p6df::modules::vscode::extension::install richterger.perl
  p6df::modules::vscode::extension::install sfodje.perltidy

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::perl::vscodes::config()
#
#>
######################################################################
p6df::modules::perl::vscodes::config() {

  cat <<'EOF'
  "[perl]": {
    "editor.defaultFormatter": "sfodje.perltidy"
  }
EOF

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
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::perl::langs() {

  p6_run_dir "$P6_DFZ_SRC_DIR/tokuhirom/plenv" p6_git_cli_pull_rebase_autostash_ff_only
  p6_run_dir "$P6_DFZ_SRC_DIR/tokuhirom/Perl-Build" p6_git_cli_pull_rebase_autostash_ff_only

  # nuke the old one
  local previous=$(p6df::modules::perl::plenv::latest::installed)
  plenv uninstall -f "$previous"

  # get the shiny one
  local latest=$(p6df::modules::perl::plenv::latest)
  plenv install "$latest"
  plenv global "$latest"
  plenv rehash

  plenv install-cpanm
  plenv rehash

  cpanm --self-upgrade

  cpanm --force --notest Template \
    LWP::UserAgent \
    JSON \
    MIME::Lite \
    Text::Replace \
    Text::CSV \
    Perl::Tidy

  plenv rehash

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::perl::init(_module, dir)
#
#  Args:
#	_module -
#	dir -
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::perl::init() {
  local _module="$1"
  local dir="$2"

  p6_bootstrap "$dir"

  p6df::core::lang::mgr::init "$P6_DFZ_SRC_DIR/tokuhirom/plenv" "pl"

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6df::modules::perl::prompt::env()
#
#  Returns:
#	str - str
#
#  Environment:	 PERL5LIB
#>
######################################################################
p6df::modules::perl::prompt::env() {

#  local str="plenv_root:\t  $PLENV_ROOT
  local str="perl5lib:\t  $PERL5LIB"

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: str str = p6df::modules::perl::prompt::lang()
#
#  Returns:
#	str - str
#
#>
######################################################################
p6df::modules::perl::prompt::lang() {

  local str
  str=$(p6df::core::lang::prompt::lang \
    "pl" \
    "plenv version-name 2>/dev/null" \
    "perl -v | p6_filter_extract_between '(' ')' | p6_filter_row_select '^v5' | p6_filter_strip_leading_v")

  p6_return_str "$str"
}
