// Overriding _PTS and _WAK
// In config ACPI, _PTS to ZPTS(1,N)
// Find:     5F50545301
// Replace:  5A50545301
// or 
// In config ACPI, _PTS to ZPTS(1,S)
// Find:     5F50545309
// Replace:  5A50545309
//
// In config ACPI, _WAK to ZWAK(1,N)
// Find:     5F57414B01
// Replace:  5A57414B01
// or
// In config ACPI, _WAK to ZWAK(1,S)
// Find:     5F57414B09
// Replace:  5A57414B09
//
DefinitionBlock("", "SSDT", 2, "ACDT", "PTSWAK", 0)
{
    External(ZPTS, MethodObj)
    External(ZWAK, MethodObj)
    External(EXT1, MethodObj)
    External(EXT2, MethodObj)
    External(EXT3, MethodObj)
    External(EXT4, MethodObj)

    Scope (_SB)
    {
        Device (PCI9)
        {
            Name (_ADR, Zero)
            Name (FNOK, Zero)
            Name (MODE, Zero)
        }
    }   
    
    Method (_PTS, 1, NotSerialized) //Method (_PTS, 1, Serialized)
    {
        If (_OSI ("Darwin"))
        {
            if(\_SB.PCI9.FNOK ==1)
            {
                Arg0 = 3
            }
            If (CondRefOf(EXT1))
            {
                EXT1(Arg0)
            }
            If (CondRefOf(EXT2))
            {
                EXT2(Arg0)
            }
        }

        ZPTS(Arg0)
    }
    
    Method (_WAK, 1, NotSerialized) //Method (_WAK, 1, Serialized)
    {   
        If (_OSI ("Darwin"))
        {
            if(\_SB.PCI9.FNOK ==1)
            {
                \_SB.PCI9.FNOK =0
                Arg0 = 3
            }
            If (CondRefOf(EXT3))
            {
                EXT3(Arg0)
            }
            If (CondRefOf(EXT4))
            {
                EXT4(Arg0)
            }
        }

        Local0 = ZWAK(Arg0)
        Return (Local0)
    }
}
//EOF
