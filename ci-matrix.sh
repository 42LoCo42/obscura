#!/usr/bin/env bash
set -eEuo pipefail

check() {
	read -r hash arch name <<<"$1"

	case "$arch" in
	x86_64-linux) os="ubuntu-24.04" ;;
	aarch64-linux) os="ubuntu-24.04-arm" ;;
	*)
		echo "Unknown architecture '$arch'!" >&2
		exit 1
		;;
	esac

	if curl -fs "https://attic.eleonora.gay/default/$hash.narinfo" >/dev/null; then
		state="[1;32mCACHE[m"
	else
		state="[1;31mBUILD[m"
		jq -cn '{
		  os:   $ARGS.positional[0],
		  arch: $ARGS.positional[1],
		  name: $ARGS.positional[2],
		}' --args "$os" "$arch" "$name"
	fi

	echo "[$state] $hash $arch $name" >&2
}
export -f check

jq -r '
   to_entries[]
   | .key as $arch
   | .value
   | to_entries[]
   | "\(.value) \($arch) \(.key)"
' <hashes.json |
	parallel -j16 --will-cite check |
	jq -cs 'if . == [] then empty else {"include": .} end' |
	sed 's|^|matrix=|'
