# Dell特殊补丁

### 要求

- 检查ACPI是否存在下列 `Device` 和 `Method` ，并且名称相符，否则忽略本章内容。
  -  `Device` ：ECDV【PNP0C09】
  -  `Device` ：LID0【PNP0C0D】
  -  `Method` ：OSID
  -  `Method` ：BRT6
  -  `Method` ：BTNV

### 特殊补丁

-   ***SSDT-OCWork-dell*** 
   - 传统亮度快捷键补丁需要 ***SSDT-OCWork-dell*** 才能正常工作。
   - 修改补丁里的 `ACSE` 可以设置工作模式。
     -  `\_SB.ACSE` = 0为 win7 模式，在此模式下，机器睡眠期间呼吸灯闪烁。
     -  `\_SB.ACSE` = 1为 win8 模式，在此模式下，机器睡眠期间呼吸灯灭。

- 修复 Fn+Insert 功能键的补丁集合
  
  -  ***SSDT-PTSWAK***   参见《PTSWAK综合补丁和扩展补丁》
  -  ***SSDT-EXT4-WakeScreen***   参见《PTSWAK综合补丁和扩展补丁》
  
  -  ***SSDT-LIDpatch***   参见《PNP0C0E睡眠修正方法》
  
  -  ***SSDT-FnInsert_BTNV-dell***   参见《PNP0C0E睡眠修正方法》

