# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::perl::plenv::latest()
#
#>
######################################################################
p6df::modules::perl::plenv::latest() {

  plenv install -l | p6_filter_row_select "5\.[0-9][02468]\." | p6_filter_row_first "1" | p6_filter_strip_spaces
}

######################################################################
#<
#
# Function: p6df::modules::perl::plenv::latest::installed()
#
#>
######################################################################
p6df::modules::perl::plenv::latest::installed() {

  plenv install -l | p6_filter_row_select "5\.[0-9][02468]\." | p6_filter_row_from_end "2" | p6_filter_strip_spaces
}
