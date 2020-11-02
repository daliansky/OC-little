# ACPI 表单

### 简述

- ACPI（Advanced Configuration & Power Interface）是电脑高级配置和电源接口，它是由Intel，Microsoft等厂商共同制定的一种电源管理标准，即 [`ACPI规范`](https://www.acpica.org/documentation) 。每台电脑出厂时都会提供符合 [`ACPI规范`](https://www.acpica.org/documentation) 的一组二进制文件，这些文件我们称之为 ACPI 表单。ACPI 表单的数量和内容随机器不同而不同，亦随BIOS版本不同而 **可能** 不同。ACPI 表单包括：
  - 1个 DSDT.aml
  - 多个 SSDT-***.aml。如： `SSDT-SataAhci.aml` 、 `SSDT-CpuSsdt.aml` 、 `SSDT-CB-01.aml` 等等
  - 其他 aml。如： `APIC.aml` 、 `BGRT.aml` 、 `DMAR.aml` 、 `ECDT.aml` 等等
- 一些工具软件和引导器可以提取机器的 ACPI 表单，像 windows 下的 Aida64，引导器 clover 等。因为 ACPI 表单是二进制文件，所以我们需要一个反编译软件来帮助我们读懂文件内容，如 MAC 系统的 MaciASL 。当用反编译软件打开这些表单时，特别是打开 DSDT.aml 时，可能会出现很多错误。需要说明的是绝大多数情况下，这些错误是软件反编译过程产生的，机器提供的 ACPI 表单并不存在这些错误。
- ACPI 表单通过 aml 语言形式来描述机器的硬件信息，它本身没有任何驱动能力。然而，某个硬件的正常工作需要正确的 ACPI，错误的描述方法会导致引导失败或者系统崩溃。比如，机器安插了博通网卡，如果 ACPI 描述为 Intel 网卡，那么系统会加载 Intel 网卡驱动，这显然是错误的。再比如，机器没有提供 `自动调节亮度` 的硬件，即使 ACPI 添加了 `SSDT-ALS0` 也无法实现亮度的自动调节功能。
- 由于 windows 系统和 MAC 系统的工作原理不同，黑苹果需要修正 ACPI 。正确的 ACPI 是黑苹果稳定工作的基础。 **强烈建议** 使用 `热补丁`【HOTpatch】对 ACPI 实施补丁。 `热补丁` 可以很好的规避所谓的 DSDT 错误。
- 有关 ACPI 的详细内容请查看 [`ACPI规范`](https://www.acpica.org/documentation) ；有关 aml 语言的介绍请参阅《ASL语法基础》。
- 本章 `ACPI 补丁` 仅适用于 `OpenCore` 

### ACPI 补丁

- DSDT 补丁和 SSDT 补丁

  这部分内容参考《OC-little》其他章节。

- 其他表单补丁

  - **清除 ACPI 的 `header fields`** 
    - **补丁方法**：`ACPI\Quirks\NormalizeHeaders` = `true` 
    - **说明**：只有 Mac 10.13 才需要这个补丁
  - **重新定位 ACPI 内存区域** 
    - **补丁方法**：`ACPI\Quirks\RebaseRegions` = `true` 
    - **说明**：ACPI 表单的内存区域既有动态分配的地址，也有固定分配的地址。补丁的作用是 **重新定位 ACPI 内存区域** ，这个操作非常危险，除非这个补丁可以解决引导崩溃问题，否则不要选用它。
  - **FACP.aml** 
    
    - **补丁方法**：`ACPI\Quirks\FadtEnableReset` = `true` 
    
    - **说明**：[`ACPI规范`](https://www.acpica.org/documentation) 以 **FADT** 来定义与配置和电源管理相关的各种静态系统信息，在机器的 ACPI 表单中以 **FACP.aml** 表单出现。 **FACP.aml** 表单表征的信息有 RTC时钟，电源和睡眠按键，电源管理等。目前和黑苹果有关的有以下几个方面：
    
    - 重启和关机不正常的，尝试使用本补丁
      
    - 按下 **电源键** 无法呼出 “重新启动、睡眠、取消、关机” 菜单的，尝试使用本补丁
      
      **注意**：如果 `ACPI\Quirks\FadtEnableReset` = `true` 依然无法呼出 “重新启动、睡眠、取消、关机” 菜单，尝试添加 ***SSDT-PMCR*** 。 ***SSDT-PMCR*** 位于 OC-little 的《添加缺失的部件》。
      
    - **FACP.aml** 表单的 `Low Power S0 Idle` 、`Hardware Reduced` 表征了机器类型，决定了电源管理方式。如果 `Low Power S0 Idle` = `1` 则表明机器属于 `AOAC` 。有关 `AOAC` 方面的内容参见《关于AOAC》。
    
  - **FACS.aml** 
    - **补丁方法**：`ACPI\Quirks\ResetHwSig` = `true` 
    - **说明**：**FACS.aml** 表单的 `Hardware Signature` 项是4字节的硬件签名，是系统引导后根据基本硬件配置计算得出的。如果机器从 **休眠** 状态 **唤醒** 后这个值发生了改变系统将无法正确恢复。补丁的作用是使 `Hardware Signature` = `0` 尝试解决上述问题。
    - **注意：**如果系统已经禁用了 **休眠** 就无需理会该补丁
  - **BGRT.aml** 
    - **补丁方法**：`ACPI\Quirks\ResetLogoStatus` = `true` 
    - **说明**：**BGRT.aml** 表单是引导图形资源表。根据 [`ACPI规范`](https://www.acpica.org/documentation) ，表单的 `Displayed` 项应该 = `0` 。但是部分厂商出于某个原因 `Displayed` 项写入了非零数据，这可能导致引导阶段屏幕刷新失败。补丁的作用是使 `Displayed` = `0` 。
    - **注意：**并非所有机器都有这个表单
  - **DMAR.aml** 
    - **补丁方法**：`Kernel\Quirks\DisableIoMapper` = `true` 
    - **说明**：补丁的作用同 BIOS 禁止 `VT-d` 或者 Drop **DMAR.aml** 
    - **注意**：只有早期 Mac 系统才需要这个补丁
  - **ECDT.aml** 
    
    - **补丁方法**：全局更名使所有 ACPI 表单的 `EC` 名称、路径和 `Namepath` 一致
    - **说明**：个别机器（如 **Lenovo yoga-s740**）的 **ECDT.aml** 表单的 `Namepath` 与其他 ACPI 表单的 `EC` 名称不一致，这会导致机器在引导过程中出现 ACPI 错误。本补丁方法可以较好的解决 ACPI 报错问题。
    - **注意**：并非所有机器都有这个表单
