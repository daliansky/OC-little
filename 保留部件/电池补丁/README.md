# 电池热补丁收录及方法指导

## 前言

在黑苹果中，大部分电脑都可以通过：
SMCBatteryManager.kext
驱动你的电池电量显示

如很不幸，上述驱动无法驱动您的电池信息，你可能需要
一：SMCBatteryManager.kext+ECEnabler.kext组合读取EC操作区域，让macOS支持1byte以上的字节

如果上述方法还是不行，请阅读下面的ACPI部分

## 电池热补丁收录

本项目收录了部分笔记本的 OpenCore 电池热补丁(如 ThinkPad 系列笔记本)，供大家参考使用

更多已经制作好的电池热补丁可参考 神楽小白(GZ小白) 的收录项目

项目页面：<https://github.com/GZXiaoBai/Hackintosh-Battery-Hotpatch>

## 电池热补丁教程

如果你想了解和学习电池热补丁的制作方法，可前往 XStarDev 的教程网站学习，有问题请去 `Issues` 页面提出（请不要问太过低级的问题，否则一律视为 Invalid）

- 教程页面：
  - <https://xstar-dev.github.io/hackintosh_advanced/Guide_For_Battery_Hotpatch.html>
  - <https://blog.gzxiaobai.cn/post/进阶：电池热补丁（Battery-Hotpatch）之路>
- 问题解答：<https://github.com/XStar-Dev/xstar-dev.github.io/issues>



## Thanks

- Rehabman（编写早期电池补丁教程并开发了 ACPIBatteryManager 电池驱动项目）
- 宪武（ThinkPad 系列笔记本电池补丁示例）
- 神楽小白(GZ小白)（电池热补丁收录、电池热补丁教程）
- XStarDev（电池热补丁教程）
