# SSDT 补丁加载顺序

- 通常情况下，我们的 SSDT 补丁的对象是机器的 ACPI (DSDT 或者其他 SSDT 文件)，这些原始的 ACPI 加载的时间早于我们的 SSDT 补丁。因此，我们的 SSDT 补丁在 `Add` 列表中 **没有顺序要求**。
- 有这样一种情况，当我们在一个 SSDT 补丁里定义了一个 `Device` 设备，又在另一个 SSDT 补丁里通过 `Scope` 引用这个 `Device`，那么，这两个补丁在 `Add` 列表中 **有顺序要求**。

## 示例

- 补丁1：**SSDT-XXXX-1.aml**
  
  ```Swift
  External (_SB.PCI0.LPCB, DeviceObj)
  Scope (_SB.PCI0.LPCB)
  {
      Device (XXXX)
      {
          Name (_HID, EisaId ("ABC1111"))
      }
  }
  ```
  
- 补丁2：**SSDT-XXXX-2.aml**

  ```Swift
  External (_SB.PCI0.LPCB.XXXX, DeviceObj)
  Scope (_SB.PCI0.LPCB.XXXX)
  {
        Method (YYYY, 0, NotSerialized)
       {
           /* do nothing */
       }
    }
  ```
  
- `Add` 列表要求

  ```XML
  Item 1
            path    <SSDT-XXXX-1.aml>
  Item 2
            path    <SSDT-XXXX-2.aml>
  ```
