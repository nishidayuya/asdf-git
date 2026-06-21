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
    - eg. Runnable Debian GNU/Linux 12 case is [here](vagrant/mise/provision_scripts/020-install_git_build_dependencies) !

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

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/nishidayuya/asdf-git/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Yuya.Nishida.](https://github.com/nishidayuya/)
