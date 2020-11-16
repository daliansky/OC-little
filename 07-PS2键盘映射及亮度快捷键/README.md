# PS2键盘映射及亮度快捷键

## 描述

- 通过键盘映射可以实现某个按键被按下后产生另一个按键的效果。比如，可以指定按下 `A/a` 后，打印输出的是 `Z/z`。再比如，指定 `F2` 实现原来 `F10` 的功能。
- 新版【9月30日】 **VoodooPS2Controller.kext** 将亮度快捷键部分分离出独立驱动 **BrightnessKeys.kext** 并由它提供方法 `Notify (^^^GFX0.***, 0x86)` 和 `Notify (^^^GFX0.***, 0x87)` ，传统的亮度快捷键补丁不再需要。如果新的驱动无效请参考本章内容指定 2 个按键映射到 `F14`, `F15`，以实现快捷键调节亮度功能。
  - **VoodooPS2Controller.kext** ：https://github.com/acidanthera/VoodooPS2
  - **BrightnessKeys.kext** ：https://github.com/acidanthera/BrightnessKeys
  
  **注意**：一些 dell 机器和 asus 机器需要 `SSDT-OCWork-***` 或者 `操作系统补丁` 才能解除对 `Notify (^^^GFX0.***, 0x86)` 和 `Notify (^^^GFX0.***,0x87)` 的限制，让 **BrightnessKeys.kext** 正常工作。详细内容请参考《Dell机器特殊补丁》、《Asus机器特殊补丁》。
- 不是所有按键都可以实现映射，只有 MAC 系统下能够捕捉到 `PS2 扫描码` 的按键才可以映射。

## 要求

- 使用 **VoodooPS2Controller.kext** 以及它的子驱动。
- 清除之前的、其他方法的按键映射内容。

### PS2 扫描码 和 ABD 扫描码

一个按键会产生 2 种扫描码，分别是 **PS2 扫描码** 和 **ABD 扫描码**。比如 `Z/z` 键的 PS2 扫描码是 `2c`, ABD 扫描码是 `6`。因为扫描码的不同，对应了两种映射方法，分别是：

- `PS2 扫描码 —> PS2 扫描码`
- `PS2 扫描码 —> ADB 扫描码`

### 获取键盘扫描码

- 查阅头文件 `ApplePS2ToADBMap.h`，文件中列举了大多数按键的扫描码。

- 控制台获取键盘扫描码（二选一）

  - 终端安装 `ioio`

    ```bash
      ioio -s ApplePS2Keyboard LogScanCodes 1
    ```

  - **修改** `VoodooPS2Keyboard.kext\info\IOKitPersonalities\Platform Profile\Default\`**`LogScanCodes`** `=` **`1`**

  打开控制台，搜索 `ApplePS2Keyboard`。按下按键，如 `A/a`，`Z/z`。

  ```log
    11:58:51.255023 +0800 kernel  ApplePS2Keyboard: sending key 1e=0 down
    11:58:58.636955 +0800 kernel  ApplePS2Keyboard: sending key 2c=6 down
  ```

  其中：

  第一行的 `1e=0` 中的 `1e` 是 `A/a` 键的 PS2 扫描码，`0` 是 ADB 扫描码。

  第二行的 `2c=6` 中的 `2c` 是 `Z/z` 键的 PS2 扫描码，`6` 是 ADB 扫描码。

### 映射方法

通过修改 `VoodooPS2Keyboard.kext\info.plist` 文件和添加第三方补丁文件的方法可以实现键盘映射。推荐使用第三方补丁文件的方法。

示例：***SSDT-RMCF-PS2Map-AtoZ***。`A/a` 映射 `Z/z`。

- `A/a` PS2 扫描码:`1e`
- `Z/z` PS2 扫描码:`2c`
- `Z/z` ADB 扫描码:`06`

以下两种映射方法任选其一

#### PS2 扫描码 —> PS2 扫描码

```Swift
    ...
      "Custom PS2 Map", Package()
      {
          Package(){},
          "1e=2c",
      },
    ...
```

#### PS2 扫描码 —> ADB 扫描码

```Swift
    ...
    "Custom ADB Map", Package()
    {
        Package(){},
        "1e=06",
    }
    ...
```

### 注意事项

- 示例中的键盘路径是 `\_SB.PCI0.LPCB.PS2K`，使用时应保证其路径和 ACPI 的键盘路径一致。大多数 Thinkpad 机器的键盘路径是 `\_SB.PCI0.LPC.KBD` 或者 `\_SB.PCI0.LPCB.KBD`。

- 补丁里使用了变量 `RMCF` ，如果其他**键盘补丁**里也使用了 `RMCF`，必须合并后使用。参见 ***SSDT-RMCF-PS2Map-dell***。`注`：***SSDT-RMCF-MouseAsTrackpad*** 用于强制开启触摸板设置选项。

- 在 VoodooPS2 中，<kbd>PrtSc</kbd> 按键对应的 PS2 扫描码是 `e037`，即触摸板（以及 ThinkPad 机器的小红点）的开关。可以将该按键映射到 `F13`、并在「系统偏好设置」中将 `F13` 绑定到截图功能上：

```Swift
    ...
    "Custom ADB Map", Package()
    {
        Package(){},
        "e037=64", // PrtSc -> F13
    }
    ...
```

![](https://i.loli.net/2020/04/01/gQqVC2YKFweSARZ.png)
