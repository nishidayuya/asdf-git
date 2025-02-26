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
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add git
# or
asdf plugin add git https://github.com/nishidayuya/asdf-git.git
```

git:

```shell
# Show all installable versions
asdf list-all git

# Install specific version
asdf install git latest

# Set a version globally (on your ~/.tool-versions file)
asdf global git latest

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
