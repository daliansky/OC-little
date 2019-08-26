# 禁用EHCx

#### 描述

下列情况之一需要禁用EHC1和EHC2总线：

- ACPI包含EHC1或者EHC2，而机器本身不存在相关硬件。
- ACPI包含EHC1或者EHC2，机器存在相关硬件但并没有实际输出端口（外置和内置）。

#### 补丁

- `SSDT-EHC1_OFF`：禁用EHC1。
- `SSDT-EHC2_OFF`：禁用EHC2。
- `SSDT-EHCx_OFF`：是`SSDT-EHC1_OFF`和`SSDT-EHC2_OFF`的合并补丁。

#### 使用方法

- 优先BIOS设置：`XHCI Mode` = `Enabled`。
- 如果BIOS没有`XHCI Mode`选项，同时符合描述的情况之一，使用上述补丁。

#### 注意事项

- 适用于7，8，9系机器，且OS是10.11以上版本。
- 对于7系机器，`SSDT-EHC1_OFF`和`SSDT-EHC2_OFF`二者不可同时使用。

