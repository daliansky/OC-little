## OC-efi主要驱动程序说明

**efi驱动目录：`UEFI/Drivers`**

- `ApfsDriverLoader`

  APFS文件系统的驱动程序。

- `AppleUiSupport`

  苹果系统特有的用户界面驱动程序。
  
- `AptioInputFix`

  用户输入驱动程序，包括鼠标驱动。和`UsbKbDxe`作用相同，某些机器`UsbKbDxe`可能工作的更好。

- `UsbKbDxe`

  和`AptioInputFix`作用相同，`AptioInputFix`、`UsbKbDxe`二选一使用。

- `AptioMemoryFix`

  内存补丁驱动。补丁内容取决于config各段的`Quirks` 。

- `VirtualSmc`

  SMC仿真驱动。一般情况使用这个驱动。

  注：和`SMCHelper`不兼容。

- `VBoxHfs`

  HFS文件系统的驱动程序。是苹果系统`HFSPlus`驱动的替代品。

- `NvmExpressDxe`

  NVMe硬盘驱动程序。`Broadwell`以后已集成到固件中。

- `EmuVariableRuntimeDxe`

  NVRAM仿真驱动程序。支持原生NVRAM的机器不需要这个程序。