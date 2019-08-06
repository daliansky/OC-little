# OC-efi 主要驱动程序说明

**EFI 驱动目录：`UEFI/Drivers`**

- `ApfsDriverLoader`

  APFS文件系统的驱动程序。

- `AppleUiSupport`

  苹果系统 File Vault 2 特有的用户界面驱动程序。
  
- `AptioInputFix`

  用户输入驱动程序，包括鼠标驱动。和`UsbKbDxe`作用相同，某些机器`UsbKbDxe`可能工作的更好。

- `UsbKbDxe`

  和 `AptioInputFix` 作用相同，`AptioInputFix`、`UsbKbDxe`二选一使用。

- ~~`AptioMemoryFix`~~

  ~~内存补丁驱动。补丁内容取决于config各段的`Quirks`~~ 已于 2019.8.6 废止，内容合并入 OpenCore 和 AppleSupportPkg，并停止对 Clover 的支持。

- `VirtualSmc`

  SMC 仿冒驱动。一般情况使用这个驱动。

  注：和 `SMCHelper` 不兼容。

- `VBoxHfs`

  HFS 文件系统的驱动程序。是苹果系统 `HFSPlus` 驱动的替代品。

- `NvmExpressDxe`

  NVMe 硬盘驱动程序。`Broadwell` 以后已集成到固件中。

- `EmuVariableRuntimeDxe`

  NVRAM 模拟驱动程序。支持原生 NVRAM 的机器不需要这个程序，需要配合 OC 的 NVRAM.plist 生成脚本。
