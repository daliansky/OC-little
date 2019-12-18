# 仿冒以太网

## 描述

一些机器无以太网，仿冒以太网实现APP正常下载功能。

## 使用

- 添加 ***SSDT-LAN*** 至 `OC\ACPI` 。

- 添加 **NullEthernet.kext** 至 `OC\Kexts` 。

- 在config中添加相关列表。

  

## 附：重置以太网 `BSD Name` 为`en0`

- 打开 **系统偏好设置** 的 **网络** 。
- 删除所有网络，如图《清除所有网络》。
- 删除 `资源库\Preferences\SystemConfiguration\NetworkInterfaces.plist` 文件。
- 重启。
- 再次进入系统后，再次打开 **系统偏好设置** 的 **网络** 。
- 依次按顺序添加 **以太网** 和其他需要的网络，点击 **应用**。

