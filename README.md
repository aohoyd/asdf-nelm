<div align="center">

# asdf-nelm [![Build](https://github.com/aohoyd/asdf-nelm/actions/workflows/build.yml/badge.svg)](https://github.com/aohoyd/asdf-nelm/actions/workflows/build.yml) [![Lint](https://github.com/aohoyd/asdf-nelm/actions/workflows/lint.yml/badge.svg)](https://github.com/aohoyd/asdf-nelm/actions/workflows/lint.yml)

[nelm](https://github.com/werf/nelm) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add nelm
# or
asdf plugin add nelm https://github.com/aohoyd/asdf-nelm.git
```

nelm:

```shell
# Show all installable versions
asdf list-all nelm

# Install specific version
asdf install nelm latest

# Set a version globally (on your ~/.tool-versions file)
asdf global nelm latest

# Now nelm commands are available
nelm --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/aohoyd/asdf-nelm/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Alexey Olshanskiy](https://github.com/aohoyd/)
