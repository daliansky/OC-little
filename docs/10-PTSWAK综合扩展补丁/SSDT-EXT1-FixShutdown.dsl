// Fix "restart after shutdown"
// Credit RehabMan (Laptop-DSDT-Patch)
DefinitionBlock("", "SSDT", 2, "OCLT", "EXT1", 0)
{
    External (_SB_.PCI0.XHC_.PMEE, FieldUnitObj)

    Method (EXT1, 1, NotSerialized)
    {
        If ((5 == Arg0) && CondRefOf (\_SB.PCI0.XHC.PMEE)) {
            \_SB.PCI0.XHC.PMEE = 0
        }
    }
}
//EOF
