# PCI设备ASPM

## 描述

- ASPM 即 **活动状态电源管理** （Active State Power Management），它是系统层面支持的一种电源链接管理方案。在 ASPM 管理下，当 PCI 设备空闲时尝试进入节电模式。

- ASPM 几种工作模式
  - L0—正常模式。
  - L0s—待机模式。L0s模式能够快速进入或退出空闲状态，进入空闲状态后，设备置于较低的功耗。
  - L1—低功耗待机模式。L1相比L0s会进一步降低功耗。但进入或退出空闲状态的时间比L0s更长。
  - L2—辅助电源模式。略。

- 对于采用了 `AOAC` 技术的机器，尝试改变 `无线网卡` 、`SSD` 的 ASPM 模式降低机器功耗。

## 设置ASPM工作模式

### `Properties` 注入方法【 **优先使用** 】

- 分别于 PCI **父设备** 以及它的 **子设备** 注入 `pci-aspm-default`

  - **父设备**
    - L0s/L1模式：`pci-aspm-default` = `03000000` 【data】
    - L1模式：`pci-aspm-default` = `02000000` 【data】
    - 禁止ASPM：`pci-aspm-default` = `00000000` 【data】
  - **子设备**
    - L0s/L1模式：`pci-aspm-default` = `03010000` 【data】
    - L1模式：`pci-aspm-default` = `02010000` 【data】
    - 禁止ASPM：`pci-aspm-default` = `00000000` 【data】

- 示例

  小新PRO13的无线网卡ASPM默认是L0s/L1，设备路径是：`PciRoot(0x0)/Pci(0x1C,0x0)/Pci(0x0,0x0)` ，参照上述方法，通过注入 `pci-aspm-default` 改变ASPM为L1。如下：
  
  ```text
  PciRoot(0x0)/Pci(0x1C,0x0)
  pci-aspm-default = 02000000
  ......
  PciRoot(0x0)/Pci(0x1C,0x0)/Pci(0x0,0x0)
  pci-aspm-default = 02010000
  ```

#### `SSDT` 补丁方法

- SSDT 补丁也可以设置 ASPM 工作模式。如：将某个设备 ASPM 设置为 L1模式，详见示例。

- 补丁原理同《禁止PCI设备》，请参阅。

- 示例：***SSDT-PCI0.RPXX-ASPM***

  ```Swift
  External (_SB.PCI0.RP05, DeviceObj)
  Scope (_SB.PCI0.RP05)
  {
      OperationRegion (LLLL, PCI_Config, 0x50, 0x01)
      Field (LLLL, AnyAcc, NoLock, Preserve)
      {
          L1,   1
      }
  }
  
  Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          \_SB.PCI0.RP05.L1 = Zero  /* Set ASPM = L1 */
      }
  }
  ```

​  **注1**：小新 PRO13 无线网卡路径是 `_SB.PCI0.RP05`。

​  **注2**： `\_SB.PCI0.RP05.L1 = 1` 时，ASPM = L0s/L1； `\_SB.PCI0.RP05.L1 = 0` 时，ASPM = L1。

## 注意事项

- ***Hackintool.app*** 工具可以查看设备 ASPM 工作模式。
- 改变 ASPM 后，如果发生异常情况请恢复 ASPM。
