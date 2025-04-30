#!/usr/bin/env bash
set -eEuo pipefail

check() {
	read -r hash attr <<<"$1"
	if curl -fs "https://attic.eleonora.gay/default/$hash.narinfo" >/dev/null; then
		state="[1;32mCACHE[m"
	else
		state="[1;31mBUILD[m"
		jq -cn '{attr: $ARGS.positional[0], os: "ubuntu-24.04"}' --args "$attr"
	fi

	echo "[$state] $hash $attr" >&2
}
export -f check

parallel -j16 check <hashes |
	jq -cs 'if . == [] then empty else {"include": .} end' |
	sed 's|^|matrix=|'
