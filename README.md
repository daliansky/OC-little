# OpenCore 0.5+ 部件补丁

## 说明

依据 OpenCore 0.5+ 的要求和建议，制作本部件补丁。

## 在线手册

本仓库依赖 GitBook 并使用 GitHub Actions 构建了 Pages 服务和 PDF 手册。

- [https://ocbook.tlhub.cn](https://ocbook.tlhub.cn)
- [OpenCore 部件库](https://cdn.jsdelivr.net/gh/daliansky/OC-little/docs/OpenCore部件库.pdf)

## 主要内容

0. **总述**

   1. ASL 语法基础
   2. SSDT 补丁加载顺序
   3. ACPI 表单
   4. ASL-AML 对照表

1. **关于`AOAC`**

   1. 禁止`S3`睡眠
   2. `AOAC`禁用独显
   3. 电源空闲管理
   4. `AOAC`唤醒补丁
   5. 设置`ASPM`工作模式
   6. 睡眠自动关闭蓝牙`WIFI`

2. **仿冒设备**

   1. 仿冒`EC`
   2. RTC0
   3. 键盘无法输入的应急解决方案 `PS2N`
   4. 仿冒环境光传感器

3. **二进制更名与预置变量**

   1. OC `I2C-GPIO` 补丁

4. **操作系统补丁**

5. **注入设备**

   1. 注入 X86
   2. `PNLF` 注入方法
   3. `SBUS(SMBU)` 补丁

6. **添加缺失的部件**

7. **PS2 键盘映射 @OC-xlivans**

8. **电池补丁**

   1. Thinkpad
   2. 其它品牌

9. **禁用 EHCx**

10. **`PTSWAK` 综合扩展补丁**

11. **`PNP0C0E` 睡眠修正方法**

12. **`0D6D` 补丁**

    1. 普通的 `060D` 补丁
    2. 惠普特殊的 `060D` 补丁

13. **仿冒以太网和重置以太网 `BSD Name`**

14. **亮度快捷键**

15. **`CMOS` 相关**

    1. `CMOS` 重置补丁
    2. `CMOS` 内存和 ***RTCMemoryFixup***

16. **`ACPI` 定制 `USB` 端口**

17. **禁止`PCI`设备**

18. **ACPIDebug**

19. **品牌机器特殊补丁**

    1. `Dell`机器特殊补丁
    2. 小新 PRO13 特殊补丁
    3. ThinkPad 机器专用补丁

20. **`I2C` 专用部件**

21. **声卡 `IRQ` 补丁**

22. **`SSDT`屏蔽独显方法**

**常见驱动加载顺序：**

   1. config-1-Lilu-SMC-WEG-ALC 驱动列表
   2. config-2-PS2 键盘驱动列表
   3. config-3-BCM 无线和蓝牙驱动列表
   4. config-4-I2C 驱动列表
   5. config-5-PS2Smart 键盘驱动列表

### Credits

- 特别感谢：
  - @宪武 制作的适用于 **[OpenCore](https://github.com/acidanthera/OpenCorePkg)** 的 ACPI 部件补丁
  - @Bat.bat, @黑果小兵, @套陆, @iStar丶Forever 审核完善

- 感谢：
  - @冬瓜-X1C5th
  - @OC-xlivans
  - @Air 13 IWL-GZ-Big Orange (OC perfect)
  - @子骏oc IWL
  - @大勇-小新air13-OC-划水小白
  - ......

- **Thanks for [Acidanthera](https://github.com/acidanthera) maintaining [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg)**
