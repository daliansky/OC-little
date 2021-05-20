# Overview

## ACPI Rename and Patch

- The rename method is not recommended, try to avoid it, e.g. `HDAS rename HDEF` , `EC0 rename EC` , `SSDT-OC-XOSI`. A special **caution** for those renaming `MethodObj` (e.g _STA、 _OSI).
- Generally speaking:
  - The OS patch is not neccessary. If components are restricted by a specific OS, please modify the ACPI patch accordingly. **Caution** for `OS Patch`

  - The keyboard brightness keys patch is not necessary for some machines. Applying `PS2 Keyboard Mapping & Brightness Function` instead.

  - So far, the overwhelming majority of machines solve `instant wake` through `0D6D patch`.

  - For batterys, if data splitting is required, the renames and patches for the battery are neccessary.
  
  - Most of Thinkpad machines require `PTSWAK extensional patch` to solve the problems that related to the breathing light.
  
  - The `PNP0C0E Sleep Adjust Method` is useful for those machines have the 💤 or 🌙 key. 
  

- You may need to disable or enable a component to solve a spcific problem. The methods are:
  - `Binary Renames & Preset Variables`-----the binary rename method is espcially effective. **Caution**, you should evaluate the negative impacts for multi-systems, since the binary rename applys for all systems.
  
  - The `Fake Devices` method is reliable. **Recommend** 

## Important Patches

- ***SSDT-RTC0***  ——under`Fake Devices`

  RTC【PNP0B00】in some machines is disabled, leading to panic on the very early stage. Use ***SSDT-RTC0***  to patch it.

- ***SSDT-EC*** ——Under`Fake EC`

  For **MacOS 10.15+**,***SSDT-EC*** is neccessary if the `Embedded Controller` is not named as `EC`, otherwise, panic.