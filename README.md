## Zig MCU Project Template

<div align="center">
  <picture>
    <img alt="Zig Logo" src="docs/assets/logo/zero.svg" height="35%" width="35%">
  </picture>
</div>
<br>

[![Tests](https://img.shields.io/github/actions/workflow/status/habedi/template-mcu-project-zig/tests.yml?label=tests&style=flat&labelColor=282c34&logo=github)](https://github.com/habedi/template-mcu-project-zig/actions/workflows/tests.yml)
[![Code Coverage](https://img.shields.io/codecov/c/github/habedi/template-mcu-project-zig?label=coverage&style=flat&labelColor=282c34&logo=codecov)](https://codecov.io/gh/habedi/template-mcu-project-zig)
[![Zig Version](https://img.shields.io/badge/Zig-0.15.1-orange?logo=zig&labelColor=282c34)](https://ziglang.org/download/)
[![MicroZig Version](https://img.shields.io/badge/MicroZig-0.15.1-orange?logo=zig&labelColor=282c34)](https://microzig.tech/)
[![Docs](https://img.shields.io/badge/docs-read-007ec6?label=docs&style=flat&labelColor=282c34&logo=readthedocs)](docs)
[![License](https://img.shields.io/badge/license-MIT-007ec6?label=license&style=flat&labelColor=282c34&logo=open-source-initiative)](LICENSE)

---

This is a template for microcontroller projects written in Zig.

---

### Getting Started


```shell
# Enter the Nix dev shell and install the Python tools
make shell
make install

# Run the host-side tests (no board needed)
make test

# Build the firmware (produces zig-out/firmware/blinky.uf2)
make build

# Flash the MCU over USB
make flash
```

```shell
# See all available commands and their descriptions
make help
```

---

### Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to make a contribution.

### License

This project is licensed under the MIT License ([LICENSE](LICENSE) or https://opensource.org/licenses/MIT)
