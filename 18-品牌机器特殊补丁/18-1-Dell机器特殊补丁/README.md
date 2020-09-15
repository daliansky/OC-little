# Dell机器特殊补丁

## 要求

- 检查ACPI是否存在下列 `Device` 和 `Method` ，并且名称相符，否则忽略本章内容。
  - `Device` ：ECDV【PNP0C09】
  - `Device` ：LID0【PNP0C0D】
  - `Method` ：OSID
  - `Method` ：BRT6
  - `Method` ：BTNV

## 特殊补丁

- ***SSDT-OCWork-dell***
  - ***亮度快捷键*** 补丁需要本补丁才能正常工作。
  - 修改补丁里的 `ACSE` 可以设置工作模式。
    - `\_SB.ACSE` = 0为 win7 模式，在此模式下，机器睡眠期间呼吸灯闪烁。
    - `\_SB.ACSE` = 1为 win8 模式，在此模式下，机器睡眠期间呼吸灯灭。

  **注**： ***操作系统补丁*** 同样可以让 ***亮度快捷键*** 补丁工作。通常情况下不建议使用 ***操作系统补丁*** 。

- 修复 Fn+Insert 功能键的补丁组合
  
  - ***SSDT-PTSWAK***   参见《PTSWAK综合扩展补丁》
  - ***SSDT-EXT4-WakeScreen***   参见《PTSWAK综合扩展补丁》
  - ***SSDT-LIDpatch***   参见《PNP0C0E睡眠修正方法》
  - ***SSDT-FnInsert_BTNV-dell***   参见《PNP0C0E睡眠修正方法》

## 其他补丁(参考)

- ***SSDT-EC*** ——参见《仿冒EC》
- ***SSDT-PLUG-xxx*** ——参见《注入X86》
- ***SSDT-PNLF-xxx*** ——参见《PNLF注入方法》
- ***SSDT-BKeyBRT6-Dell*** ——参见《亮度快捷键》
- ***SSDT-GPRW*** ——参见《0D6D补丁》
- ***SSDT-ALS0*** ——参见《仿冒环境光传感器》
- ***SSDT-MCHC*** ——参见《添加缺失的部件》
- ***SSDT-SBUS*** ——参见《SBUS/SMBU补丁》
- ***SSDT-OCI2C-TPXX-dell5480*** ——参见《I2C专用部件》，适用于 `dell_Latitude5480`
- ***SSDT-RMCF-MouseAsTrackpad*** ——参见《PS2键盘映射》
- ***SSDT-RP01.PXSX-disbale*** ——参见《禁止PCI设备》，用于禁止 `dell_Latitude5480` 的SD卡

**注**：以上补丁所要求的更名在对应补丁文件的注释里。
