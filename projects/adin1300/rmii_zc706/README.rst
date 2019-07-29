- Connect on FMC LPC
- VADJ 1.8v
- RMII mode, using MII to RMII adapter, connected to the PS7's GMII_ETHERNET_1

RMII mode requires that these be changed on the on the ADIN1300 reference board:
    - Resistors R119 & R15 be disconnected (to disconnect the XTAL circuitry)
    - Resistor R120 connected
    - R8 & R27 connected with 10k resistors each (MAC Interface configuration, MACIF_SEL0, MACIF_SEL1)
