# 亮度快捷键补丁

## 更名和补丁

- Thinkpad

  - 更名1：`_Q14` to `XQ14` (TP-up)
  - 更名2：`_Q15` to `XQ15` (TP-down)
  - 补丁1： SSDT-BKeyQ14Q15-TP-`LPC`
  - 补丁2： SSDT-BKeyQ14Q15-TP-`LPCB`

  **注意**：Thinkpad 机器有的是 `LPC`，有的是 `LPCB`，注意选用合适的补丁文件。

- 联想小新 IKB/IKBR/IWL

  - 更名1：`_Q12` to `XQ12` (LenovoAir-up)
  - 更名2：`_Q11` to `XQ11` (LenovoAir-down)
  - 补丁： ***SSDT-BKeyQ11Q12-LenAir***
  
- 联想PRO13-IML

  - 更名1：`_Q38` to `XQ38` (LenovoPRO13-up)
  - 更名2：`_Q39` to `XQ39` (LenovoPRO13-down)
  - 补丁： ***SSDT-BKeyQ38Q39-LenovoPRO13*** 

### 如何查找亮度快捷键的位置

- 一般情况下，亮度快捷键是 `EC` 的 `_Qxx`，这个 `_Qxx` 里包涵 `Notify(***, 0x86)` 和 `Notify(***, 0x87)` 指令。如果查找不到或者无法确认，搜索 ACPI，找到 `Notify(***, 0x86)` 和 `Notify(*** 0x87)` 所在位置。根据查询到的结果参照样本制作自己的补丁文件并进行正确的更名。

- `Notify(***, 0x86)` 对应 up 键，`Notify(***, 0x87)` 对应 down 键

#### 备注

可以使用键盘映射的方法指定某两个按键实现亮度调节功能。详见《PS2键盘映射》。
