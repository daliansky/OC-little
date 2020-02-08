# 禁用EHCx

## 描述

下列情况之一需要禁用 EHC1 和 EHC2 总线：

- ACPI 包含 EHC1 或者 EHC2，而机器本身不存在相关硬件。
- ACPI 包含 EHC1 或者 EHC2，机器存在相关硬件但并没有实际输出端口（外置和内置）。

## 补丁

- ***SSDT-EHC1_OFF***：禁用 `EHC1`。
- ***SSDT-EHC2_OFF***：禁用 `EHC2`。
- ***SSDT-EHCx_OFF***：是 ***SSDT-EHC1_OFF*** 和 ***SSDT-EHC2_OFF*** 的合并补丁。

## 使用方法

- 优先 BIOS 设置：`XHCI Mode` = `Enabled`。
- 如果 BIOS 没有 `XHCI Mode`选项，同时符合 **描述** 的情况之一，使用上述补丁。

### 注意事项

- 适用于 7, 8, 9 系机器，且 macOS 是 10.11 以上版本。
- 对于 7 系机器，***SSDT-EHC1_OFF*** 和 ***SSDT-EHC2_OFF*** 二者不可同时使用。
- 补丁在 `Scope (\)`   下添加了 `_INI` 方法，如果和其他补丁的 `_INI` 发生重复，应合并 `_INI` 里的内容。
