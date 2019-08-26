# 8月21号 **`OC 0.5+`** 更新说明

- 更新 BOOTx64.efi, OpenCore.efi

- config 新增 `Uefi\Quirks\ClearScreenOnModeSwitch`, `Uefi\Quirks\ReplaceTabWithSpace`

  - `ClearScreenOnModeSwitch`

    当从图形模式切换到文本模式时，某些机器会残留切换前的部分内容。此选项在切换到文本模式之前将整个屏幕填充黑色

    `Uefi\Protocols\ConsoleControl` 设置为 **true** 才能使其工作

  - `ReplaceTabWithSpace`

    一些机器在 Shell 状态下使用 Tap 会导致显示异常

    `Uefi\Protocols\ConsoleControl` 设置为 **true** 才能使其工作

- config 新增项目见 `新增0821.plist`
