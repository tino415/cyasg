#!/bin/sh

function test() {
	mix test $SELECTOR
}

function dev() {
	iex -S mix phx.server
}

function check() {
	mix compile --force && mix format
}

function format() {
  mix format
}

function package_sync() {
	mix deps.get
}

function package_clean() {
  mix deps.clean --unlock --unused
}

function migrate() {
	mix ecto.migrate
}

function rollback() {
	mix ecto.rollback
}

function build() {
	MIX_ENV=prod mix release
}

function build_help() {
  _build/prod/rel/banklink/bin/banklink
}

function build_eval() {
  set -o allexport
  source run.env
  set +o allexport
  _build/prod/rel/merchant/bin/merchant eval $COMMAND
}

function build_serve() {
  set -o allexport
  source run.env
  set +o allexport
  _build/prod/rel/merchant/bin/merchant start_iex
}

function genmigration() {
  mix ecto.gen.migration $MIGRATION_NAME
}

function migrationpath() {
  echo "$(dirname $(realpath "$0"))/apps/banklink/priv/repo/migrations"
}

function translate() {
  mix gettext.extract && mix gettext.merge --no-fuzzy ./priv/gettext/
}

echo
type "$@" | sed '1d'
"$@"
