# 禁止 PCI 设备

## 描述

- 某些情况下，我们希望禁用某个 PCI 设备。比如，PCI 总线的 SD 卡通常无法驱动，即使驱动了也几乎不能正常工作。这种情况下，我们可以通过自定义 SSDT 补丁禁用这个设备。
- 这些设备有以下特征：
  - 它是某个PCI **父设备** 的 **子设备**
  - **父设备** 定义了一些 `PCI_Config` **或者 `SystemMemory`** 类型的变量，其中偏移量0x55数据的第 `D4` 位为设备运行属性
  - **子设备** 地址： `Name (_ADR, Zero)`  

## 设备名称

- 较新机器的 **子设备** 名称为 **`PXSX`**；**父设备** 名称为 **`RP01`**，**`RP02`**，**`RP03`**...等。
- 早期 Thinkpad 机器 **子设备** 名称为 **`SLOT`** 或者 **无**；**父设备** 名称为 **`EXP1`**，**`EXP2`**，**`EXP3`**...等。
- 其他机器可能是其他名称。
- 笔记本的内置无线网卡属于这样的设备。

## SSDT 禁用补丁示例

- dell Latitude5480 的 SD 卡属于 PCI 设备，设备路径：`_SB.PCI0.RP01.PXSX`

- 补丁文件：***SSDT-RP01.PXSX-disbale***

  ```Swift
  External (_SB.PCI0.RP01, DeviceObj)
  Scope (_SB.PCI0.RP01)
  {
      OperationRegion (DE01, PCI_Config, 0x50, 0x01)
      Field (DE01, AnyAcc, NoLock, Preserve)
      {
              ,   4,
          DDDD,   1
      }
  		//possible start
  		Method (_STA, 0, Serialized)
  		{
  				If (_OSI ("Darwin"))
  				{
  					Return (Zero)
  				}
  		}
  		//possible end
  }  
  Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          \_SB.PCI0.RP01.DDDD = One
      }
  }
  ```

## 注意

- 如果 **父设备** 存在多个 **子设备** ，请 **谨慎使用** 本方法。
- 使用时请将示例中的 `RP01` 替换为被禁用设备所属 **父设备** 名称，参考示例。
- 如果被禁用设备已经包括了 `_STA` 方法，忽略 *possible start* 至 *possible end* 内容，见示例注释部分。
- 此方法并不能将设备从PCI通道中释放出。

## 感谢

- @哞🌈
