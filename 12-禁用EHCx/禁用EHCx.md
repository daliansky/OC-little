# 禁用EHCx

1. 描述

   下列情况之一需要禁用EHC1和EHC2总线：

   - ACPI包含EHC1或者EHC2，而机器本身不存在相关硬件。
   - ACPI包含EHC1或者EHC2，机器虽然具有硬件但并没有实际输出接口。

2. 补丁

   - `SSDT-EHC1_OFF`：禁用EHC1。
   - `SSDT-EHC2_OFF`：禁用EHC2。
   - `SSDT-EHCx_OFF`：禁用EHC1和EHC2，是`SSDT-EHC1_OFF`和`SSDT-EHC2_OFF`的合并补丁。

3. 方法

   - 优先BIOS设置：`XHCI Mode` = `Enabled`。
   - 如果BIOS没有`XHCI Mode`选项或者工作不正常，使用上述补丁。

4. 注意事项

   - 适用于7，8，9系机器，且OS是10.11以上版本。
   - 对于7系机器，只能使用`SSDT-EHC1_OFF`或者`SSDT-EHC2_OFF`，不可同时使用。
