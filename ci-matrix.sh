#!/usr/bin/env bash
set -eEuo pipefail

check() {
	read -r attr hash <<<"$1"
	if curl -fs "https://attic.eleonora.gay/default/$hash.narinfo" >/dev/null; then
		state="[1;32mCACHE[m"
	else
		state="[1;31mBUILD[m"
		jq -cn '{attr: $ARGS.positional[0], os: "x86_64-linux"}' --args "$attr"
	fi

	echo "[$state] $hash $attr" >&2
}
export -f check

parallel -j16 check <hashes | jq -cs 'if . == [] then empty else {"include": .} end'
