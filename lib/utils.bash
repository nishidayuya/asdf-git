#!/usr/bin/env bash

set -euo pipefail

# Ensure this is the correct GitHub homepage where releases can be downloaded for git.
GH_REPO="https://github.com/git/git"
TOOL_NAME="git"
TOOL_TEST="git version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if git is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

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
	# Adapt this. By default we simply list the tag names from GitHub releases.
	# Change this function if git has other means of determining installable versions.
	list_github_tags |
		sed '/^gitgui-/d; /^junio-gpg-pub$/d; /rc[0-9]*$/d'
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	# Adapt the release URL convention for git
	#
	# ./configure script is needed. But, GitHub.com's tag does not contain it.
	url="https://mirrors.edge.kernel.org/pub/software/scm/git/git-${version}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

# Print the contrib commands (paths relative to contrib/, e.g. "subtree" or
# "credential/netrc") whose Makefile provides an `install` target.
list_installable_contribs() {
	local contrib_base="$ASDF_DOWNLOAD_PATH/contrib"
	local makefile dir

	while IFS= read -r makefile; do
		if grep -q '^install:' "$makefile"; then
			dir="$(dirname "$makefile")"
			echo "${dir#"$contrib_base"/}"
		fi
	done < <(find "$contrib_base" -name Makefile | sort)
}

install_contribs() {
	local install_path="$1"
	local contrib_base="$ASDF_DOWNLOAD_PATH/contrib"
	local contribs contrib contrib_dir

	# ASDF_GIT_CONTRIBS is a space-separated list of contrib commands to install
	# (see lib/utils.bash documentation in README). When it is unset, every
	# contrib command that provides an install target is installed; when it is
	# set to an empty string, no contrib command is installed.
	if [ -n "${ASDF_GIT_CONTRIBS+set}" ]; then
		contribs="$ASDF_GIT_CONTRIBS"
	else
		contribs="$(list_installable_contribs)"
	fi

	for contrib in $contribs; do
		contrib_dir="$contrib_base/$contrib"

		if [ ! -d "$contrib_dir" ]; then
			echo "* Skipping contrib '$contrib': not found in this $TOOL_NAME source."
			continue
		fi
		if ! grep -q '^install:' "$contrib_dir/Makefile" 2>/dev/null; then
			echo "* Skipping contrib '$contrib': no install target in its Makefile."
			continue
		fi

		echo "* Installing contrib '$contrib'..."
		# gitexecdir defaults to $(prefix)/libexec/git-core, matching where the
		# main `make install` placed Git's own commands, so `git $contrib` works.
		# A single contrib failure (e.g. a platform-specific one) must not abort
		# the whole Git installation, so it is reported and skipped.
		if ! make -C "$contrib_dir" "-j$(nproc)" prefix="$install_path" install; then
			echo "* Warning: could not install contrib '$contrib'; skipping it."
		fi
	done
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="$3"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cd "$ASDF_DOWNLOAD_PATH"
		./configure --prefix="$install_path"
		make "-j$(nproc)"
		make install

		install_contribs "$install_path"

		# Assert git executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
