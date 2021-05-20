# 笔记本电池驱动

- 通常，笔记本电池的驱动方法是：驱动（ ***SMCBatteryManager.kext*** 或者 ***ACPIBatteryManager.kext***  +  SSDT 补丁。SSDT 补丁的作用是将多字节数据拆分为多个单字节数据，以满足驱动读写要求。实际制作 SSDT 补丁过程比较复杂、繁琐、易出错，随机器不同而不同，难以形成通用性补丁。

- ***ECEnabler.kext*** 的开发成功解决了上述问题。它替代了补丁的作用，在大多数笔记本上可以很好的工作，不再需要 SSDT 补丁了。

- 有关 ***ECEnabler.kext*** 的内容参见 https://github.com/1Revenger1/ECEnabler/releases 

- **注意：** 现阶段 ***ECEnabler.kext*** 可能无法适用于所有笔记本，有些机器的电池补丁仍然需要 SSDT 补丁方法，这些内容参见《保留部件》的《电池补丁》。

