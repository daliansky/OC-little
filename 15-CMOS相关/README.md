# CMOS相关

## CMOS重置补丁

### 描述

- 某些机器在关机或者重启时会出现 **“开机自检错误”**，这是由于 CMOS 被重置所导致的。
- 当使用 Clover 时，勾选 `ACPI\FixRTC` 可以解决上述问题。
- 当使用 OpenCore 时，官方提供了以下解决方法，见 ***Sample.plist*** ：
  - 安装 **RTCMemoryFixup.kext**
  - `Kernel\Patch` 补丁：**__ZN11BCM5701Enet14getAdapterInfoEv**
- 本章提供一种 SSDT 补丁方法来解决上述问题。这个 SSDT 补丁本质是仿冒 RTC，见《预置变量法》和《仿冒设备》。

### 解决方案

详见《15-1-CMOS重置补丁》。

## **CMOS** 内存和 RTCMemoryFixup

- 当 **AppleRTC** 与 **BIOS** 发生冲突而时，可以尝试使用 **RTCMemoryFixup** 模拟 **CMOS** 内存规避冲突。
- **RTCMemoryFixup** 下载地址：<https://github.com/acidanthera/RTCMemoryFixup>

### **CMOS** 内存

- **CMOS** 内存保存着日期、时间、硬件配置信息、辅助设置信息、启动设置、休眠信息等重要数据。
- 一些 **CMOS** 内存空间定义：
  - 日期、时间：`00-0D`
  - 休眠信息存放区间：`80-AB`
  - 电源管理：`B0-B4`
  - 其他

### 模拟 **CMOS** 内存方法

详见《15-2-CMOS内存和RTCMemoryFixup》。
