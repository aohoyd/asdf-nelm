#!/usr/bin/env bash

set -euo pipefail

DOWNLOAD_URL="https://storage.googleapis.com/nelm-tuf/targets"
PUBLIC_KEY_URL="https://raw.githubusercontent.com/werf/nelm/refs/heads/main/nelm.asc"
GH_REPO="https://github.com/werf/nelm"
TOOL_NAME="nelm"
TOOL_TEST="nelm --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# TODO: Adapt this. By default we simply list the tag names from GitHub releases.
	# Change this function if nelm has other means of determining installable versions.
	list_github_tags
}

download_release() {
	local version filename sigfilename keyfilename ringfilename platform architecture url sign_url
	version="$1"
	filename="$2"
	sigfilename="$(dirname "$filename")/nelm.sig"
	keyfilename="$(dirname "$filename")/nelm.asc"
	ringfilename="$(dirname "$filename")/nelm.gpg"

	case "$OSTYPE" in
	darwin*) platform="darwin" ;;
	linux*) platform="linux" ;;
	*) fail "Unsupported platform" ;;
	esac

	case "$(uname -m)" in
	x86_64 | x86-64 | x64 | amd64) architecture="amd64" ;;
	aarch64 | arm64) architecture="arm64" ;;
	*) fail "Unsupported architecture" ;;
	esac

	url="$DOWNLOAD_URL/releases/${version}/${platform}-${architecture}/bin/nelm"
	sign_url="$DOWNLOAD_URL/signatures/${version}/${platform}-${architecture}/bin/nelm.sig"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
	curl "${curl_opts[@]}" -o "$sigfilename" -C - "$sign_url" || fail "Could not download $sign_url"
	curl "${curl_opts[@]}" -o "$keyfilename" -C - "$PUBLIC_KEY_URL" || fail "Could not download $PUBLIC_KEY_URL"

	echo "* Verifying $TOOL_NAME release $version..."
	gpg --dearmor <"$keyfilename" >"$ringfilename"
	gpg --no-default-keyring --keyring "$ringfilename" --batch --trust-model always --verify "$sigfilename" "$filename" || fail "Could not verify $filename"

	rm "$keyfilename" "$sigfilename" "$ringfilename"

	chmod +x "$filename"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
