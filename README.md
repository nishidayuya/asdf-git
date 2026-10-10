<div align="center">

# asdf-git [![Build](https://github.com/nishidayuya/asdf-git/actions/workflows/build.yml/badge.svg)](https://github.com/nishidayuya/asdf-git/actions/workflows/build.yml) [![Lint](https://github.com/nishidayuya/asdf-git/actions/workflows/lint.yml/badge.svg)](https://github.com/nishidayuya/asdf-git/actions/workflows/lint.yml)

[git](https://git-scm.com/docs) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- Building Git dependencies:
    - gcc, make and so on.
    - Rust toolchain (`cargo` and `rustc`). Git 2.55 and later compile their
      Rust code by default. See [Building without Rust](#building-without-rust)
      if you do not want to install it.
    - eg. On Debian GNU/Linux 13:

      ```shell
      sudo apt-get install -y --no-install-recommends \
        build-essential \
        cargo \
        gettext \
        libcurl4-openssl-dev \
        libexpat1-dev \
        zlib1g-dev
      ```

# Install

Plugin:

```shell
asdf plugin add git https://github.com/nishidayuya/asdf-git.git
```

asdf-git will never be added to the official Mise registry :sob: (see https://github.com/jdx/mise/pull/4694#issuecomment-2747820332 )

git:

```shell
# Show all installable versions
asdf list all git

# Install specific version
asdf install git latest

# Set a version globally (on your ~/.tool-versions file)
asdf set -u git latest

# Now git commands are available
git version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

## Building without Rust

Git 2.55 and later compile their Rust code by default, so building them fails
when the Rust toolchain is not installed. Set the `NO_RUST` environment
variable to build Git without the features and subsystems written in Rust:

```shell
NO_RUST=1 asdf install git latest
```

## Contrib commands

Git ships extra commands under the `contrib/` directory of its source tarball.
By default this plugin builds and installs the ones that are useful on GNU/Linux
systems and build with the dependencies listed above:

- `subtree` (`git subtree`)
- `contacts` (`git contacts`)
- `credential/netrc` (`git-credential-netrc`)

```shell
git subtree --help
```

Platform-specific credential helpers that cannot build on GNU/Linux
(`credential/osxkeychain` is macOS-only, `credential/wincred` is Windows-only)
and `credential/libsecret` (which needs libsecret and GLib) are excluded from
the defaults.

You can choose exactly which contrib commands to install with the
`ASDF_GIT_CONTRIBS` environment variable (a space-separated list of paths
relative to `contrib/`). Only directories whose `Makefile` provides an `install`
target are supported, and a contrib that fails to build is reported and skipped
without aborting the Git installation:

```shell
# Install only git-subtree and git-contacts
ASDF_GIT_CONTRIBS="subtree contacts" asdf install git latest

# Also install the libsecret credential helper (needs libsecret and GLib)
ASDF_GIT_CONTRIBS="subtree contacts credential/netrc credential/libsecret" asdf install git latest

# Skip installing contrib commands entirely
ASDF_GIT_CONTRIBS="" asdf install git latest
```

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/nishidayuya/asdf-git/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Yuya.Nishida.](https://github.com/nishidayuya/)
