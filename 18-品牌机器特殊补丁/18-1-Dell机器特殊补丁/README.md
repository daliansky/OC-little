# Dell机器特殊补丁

## 要求

- 检查ACPI是否存在下列 `Device` 和 `Method` ，并且名称相符，否则忽略本章内容。
  - `Device` ：ECDV【PNP0C09】
  - `Device` ：LID0【PNP0C0D】
  - `Method` ：OSID
  - `Method` ：BTNV

## 特殊补丁

- ***SSDT-OCWork-dell***
  - 改变 `ACOS` 、 `ACSE` 可以让机器工作在不同的模式
    - `ACOS` = `0x80` ，`ACSE` = 0 为 win7 模式，在此模式下，机器睡眠期间呼吸灯闪烁
    - `ACOS` = `0x80` ，`ACSE` = 1 为 win8 模式，在此模式下，机器睡眠期间呼吸灯灭
    - `ACOS` > `0x20` ，亮度快捷键工作
    
    - 其他工作模式请查看 DSDT 的 `Method (OSID...` 有关内容
  - 多数 dell 机器的亮度快捷键受控于 `OSID` 方法，而 `OSID` 的 **返回值** 取决于操作系统本身或者使用 **本补丁** 修正其 **返回值** 【 `ACOS` > `0x20` 】
  
- 修复 Fn+Insert 功能键的补丁组合
  
  - ***SSDT-PTSWAK***   参见《PTSWAK综合扩展补丁》
  - ***SSDT-EXT4-WakeScreen***   参见《PTSWAK综合扩展补丁》
  - ***SSDT-LIDpatch***   参见《PNP0C0E睡眠修正方法》
  - ***SSDT-FnInsert_BTNV-dell***   参见《PNP0C0E睡眠修正方法》

## 其他补丁(参考)

- ***SSDT-EC*** ——参见《仿冒EC》
- ***SSDT-PLUG-xxx*** ——参见《注入X86》
- ***SSDT-PNLF-xxx*** ——参见《PNLF注入方法》
- ***SSDT-GPRW*** ——参见《0D6D补丁》
- ***SSDT-ALS0*** ——参见《仿冒环境光传感器》
- ***SSDT-MCHC*** ——参见《添加缺失的部件》
- ***SSDT-SBUS*** ——参见《SBUS/SMBU补丁》
- ***SSDT-OCI2C-TPXX-dell5480*** ——参见《I2C专用部件》，适用于 `dell_Latitude5480`
- ***SSDT-RMCF-MouseAsTrackpad*** ——参见《PS2键盘映射》
- ***SSDT-RP01.PXSX-disbale*** ——参见《禁止PCI设备》，用于禁止 `dell_Latitude5480` 的SD卡

**注**：以上补丁所要求的更名在对应补丁文件的注释里。
