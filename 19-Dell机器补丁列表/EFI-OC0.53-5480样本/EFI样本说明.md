# EFI样本说明

## EFI样本按单系统定制， <u>不包括</u> 以下内容：

- 补丁部分

  - 操作系统补丁

  - X86补丁
  - PNLF补丁
  - I2C定制补丁

- 驱动

  - 无线网卡、蓝牙
  - 以太网
  - USB定制



## 补充完善以下内容

- 添加适合自己的补丁到 `OC\ACPI` 

- 添加适合自己的驱动到 `OC\Kexts` 
- 修改config
  -  `ACPI\Add` 和 `ACPI\Patch` 部分添加补丁列表
  -  `Kernel\Add` 添加驱动列表
  - 将clover的 `Devices\Properties` 内容移植到 `DeviceProperties\Add` 
  - 将自己的机型参数填写到 `PlatformInfo\Generic` 
  - 可能需要修改的其他设置

- 定制USB端口