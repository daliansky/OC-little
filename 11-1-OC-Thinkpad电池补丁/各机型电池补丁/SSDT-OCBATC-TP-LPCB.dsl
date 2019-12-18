// ThinkPad-LPCB
DefinitionBlock ("", "SSDT", 2, "ACDT", "BATC", 0)
{
    External(\_SB.PCI0.LPCB.EC, DeviceObj)
    
    Scope(\_SB.PCI0.LPCB.EC)
    {
        External(BAT0._HID, IntObj)
        External(BAT0._STA, MethodObj)
        External(BAT0._BIF, MethodObj)
        External(BAT0._BST, MethodObj)
        External(BAT1, DeviceObj)
        External(BAT1._HID, IntObj)
        External(BAT1._STA, MethodObj)
        External(BAT1._BIF, MethodObj)
        External(BAT1._BST, MethodObj)
        Device(BATC)
        {
            Name(_HID, EisaId ("PNP0C0A"))
            Name(_UID, 0x02)

            Method(_INI)
            {
                // disable original battery objects by setting invalid _HID
                ^^BAT0._HID = 0
                ^^BAT1._HID = 0
            }

            Method(CVWA, 3)
            // Convert mW to mA (or mWh to mAh)
            // Arg0 is mW or mWh (or mA/mAh in the case Arg2==0)
            // Arg1 is mV (usually design voltage)
            // Arg2 is whether conversion is needed (non-zero for convert)
            // return is mA or mAh
            {
                If (Arg2)
                {
                    Arg0 = (Arg0 * 1000) / Arg1
                }
                Return(Arg0)
            }

            Method(_STA)
            {
                // call original _STA for BAT0 and BAT1
                // result is bitwise OR between them
                
                If (_OSI ("Darwin"))
                {
                    Return(^^BAT0._STA() | ^^BAT1._STA())
                }
                Else
                {
                    Return (0)
                }   
            }

            Name(B0CO, 0x00) // BAT0 0/1 needs conversion to mAh
            Name(B1CO, 0x00) // BAT1 0/1 needs conversion to mAh
            Name(B0DV, 0x00) // BAT0 design voltage
            Name(B1DV, 0x00) // BAT1 design voltage

            Method(_BST)
            {
                // Local0 BAT0._BST
                // Local1 BAT1._BST
                // Local2 BAT0._STA
                // Local3 BAT1._STA
                // Local4/Local5 scratch

                // gather battery data from BAT0
                Local0 = ^^BAT0._BST()
                Local2 = ^^BAT0._STA()
                If (0x1f == Local2)
                {
                    // check for invalid remaining capacity
                    Local4 = DerefOf(Local0[2])
                    If (!Local4 || Ones == Local4) { Local2 = 0; }
                }
                // gather battery data from BAT1
                Local1 = ^^BAT1._BST()
                Local3 = ^^BAT1._STA()
                If (0x1f == Local3)
                {
                    // check for invalid remaining capacity
                    Local4 = DerefOf(Local1[2])
                    If (!Local4 || Ones == Local4) { Local3 = 0; }
                }
                // find primary and secondary battery
                If (0x1f != Local2 && 0x1f == Local3)
                {
                    // make primary use BAT1 data
                    Local0 = Local1 // BAT1._BST result
                    Local2 = Local3 // BAT1._STA result
                    Local3 = 0  // no secondary battery
                }
                // combine batteries into Local0 result if possible
                If (0x1f == Local2 && 0x1f == Local3)
                {
                    // _BST 0 - Battery State - if one battery is charging, then charging, else discharging
                    Local4 = DerefOf(Local0[0])
                    Local5 = DerefOf(Local1[0])
                    If (Local4 == 2 || Local5 == 2)
                    {
                        // 2 = charging
                        Local0[0] = 2
                    }
                    ElseIf (Local4 == 1 || Local5 == 1)
                    {
                        // 1 = discharging
                        Local0[0] = 1
                    }
                    ElseIf (Local4 == 5 || Local5 == 5)
                    {
                        // critical and discharging
                        Local0[0] = 5
                    }
                    ElseIf (Local4 == 4 || Local5 == 4)
                    {
                        // critical
                        Local0[0] = 4
                    }
                    // if none of the above, just leave as BAT0 is

                    // Note: Following code depends on _BIF being called before _BST to set B0CO and B1CO

                    // _BST 1 - Battery Present Rate - Add BAT0 and BAT1 values
                    Local0[1] = CVWA(DerefOf(Local0[1]), B0DV, B0CO) + CVWA(DerefOf(Local1[1]), B1DV, B1CO)
                    // _BST 2 - Battery Remaining Capacity - Add BAT0 and BAT1 values
                    Local0[2] = CVWA(DerefOf(Local0[2]), B0DV, B0CO) + CVWA(DerefOf(Local1[2]), B1DV, B1CO)
                    // _BST 3 - Battery Present Voltage - Average BAT0 and BAT1 values
                    Local0[3] = (DerefOf(Local0[3]) + DerefOf(Local1[3])) / 2
                }
                Return(Local0)
            } // _BST

            Method(_BIF)
            {
                // Local0 BAT0._BIF
                // Local1 BAT1._BIF
                // Local2 BAT0._STA
                // Local3 BAT1._STA
                // Local4/Local5 scratch

                // gather and validate data from BAT0
                Local0 = ^^BAT0._BIF()
                Local2 = ^^BAT0._STA()
                If (0x1f == Local2)
                {
                    // check for invalid design capacity
                    Local4 = DerefOf(Local0[1])
                    If (!Local4 || Ones == Local4) { Local2 = 0; }
                    // check for invalid max capacity
                    Local4 = DerefOf(Local0[2])
                    If (!Local4 || Ones == Local4) { Local2 = 0; }
                    // check for invalid design voltage
                    Local4 = DerefOf(Local0[4])
                    If (!Local4 || Ones == Local4) { Local2 = 0; }
                }
                // gather and validate data from BAT1
                Local1 = ^^BAT1._BIF()
                Local3 = ^^BAT1._STA()
                If (0x1f == Local3)
                {
                    // check for invalid design capacity
                    Local4 = DerefOf(Local1[1])
                    If (!Local4 || Ones == Local4) { Local3 = 0; }
                    // check for invalid max capacity
                    Local4 = DerefOf(Local1[2])
                    If (!Local4 || Ones == Local4) { Local3 = 0; }
                    // check for invalid design voltage
                    Local4 = DerefOf(Local1[4])
                    If (!Local4 || Ones == Local4) { Local3 = 0; }
                }
                // find primary and secondary battery
                If (0x1f != Local2 && 0x1f == Local3)
                {
                    // make primary use BAT1 data
                    Local0 = Local1 // BAT1._BIF result
                    Local2 = Local3 // BAT1._STA result
                    Local3 = 0  // no secondary battery
                }
                // combine batteries into Local0 result if possible
                If (0x1f == Local2 && 0x1f == Local3)
                {
                    // _BIF 0 - Power Unit - 0 = mWh | 1 = mAh
                    // set B0CO/B1CO if convertion to amps needed
                    B0CO = !DerefOf(Local0[0])
                    B1CO = !DerefOf(Local1[0])
                    // set _BIF[0] = 1 => mAh
                    Local0[0] = 1
                    // _BIF 4 - Design Voltage - store value for each Battery in mV
                    B0DV = DerefOf(Local0[4]) // cache BAT0 voltage
                    B1DV = DerefOf(Local1[4]) // cache BAT1 voltage
                    // _BIF 1 - Design Capacity - add BAT0 and BAT1 values
                    Local0[1] = CVWA(DerefOf(Local0[1]), B0DV, B0CO) + CVWA(DerefOf(Local1[1]), B1DV, B1CO)
                    // _BIF 2 - Last Full Charge Capacity - add BAT0 and BAT1 values
                    Local0[2] = CVWA(DerefOf(Local0[2]), B0DV, B0CO) + CVWA(DerefOf(Local1[2]), B1DV, B1CO)
                    // _BIF 3 - Battery Technology - leave BAT0 value
                    // _BIF 4 - Design Voltage - average BAT0 and BAT1 values
                    Local0[4] = (B0DV + B1DV) / 2
                    // _BIF 5 - Design Capacity Warning - add BAT0 and BAT1 values
                    Local0[5] = CVWA(DerefOf(Local0[5]), B0DV, B0CO) + CVWA(DerefOf(Local1[5]), B1DV, B1CO)
                    // _BIF 6 - Design Capacity of Low - add BAT0 and BAT1 values
                    Local0[6] = CVWA(DerefOf(Local0[6]), B0DV, B0CO) + CVWA(DerefOf(Local1[6]), B1DV, B1CO)
                    // _BIF 7+ - Leave BAT0 values for now
                }
                Return(Local0)
            } // _BIF
        } // BATC
    } // Scope(...)
}
// EOF