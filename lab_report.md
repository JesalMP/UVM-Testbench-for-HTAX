# Coverage report


#### Failing Regression:
![alt text](image.png)

#### Passing Regression after the failing regression:
![alt text](image-2.png)
![alt text](image-3.png)

#### TestCases Mapped:
![alt text](image-1.png)
![alt text](image-9.png)

#### Assertions/Checkers for Tx interface:
![alt text](image-11.png)
![alt text](image-13.png)
![alt text](image-4.png)

#### Assertions/Checkers for Rx interface:
Buggy:![alt text](image-10.png)
BugFixed:![alt text](image-12.png)
![alt text](image-5.png)

#### Functional Coverage for Tx interface:
![alt text](image-6.png)

#### Functional Coverage for Rx interface:
![alt text](image-7.png)

#### Code Coverage:
![alt text](image-8.png)

#### Code Coverage Holes:
A 98.69% Code coverage can't be classified as having coverage hole, however these can be due to conditional code blocks that are never reached throughout test stimulus. However, as per google, a 97+ code coverage is generally considered excellent.


# Bugs report


### Bug 1

#### What is the bug?
The bug presents itself in cases and combinations of pkt.length and pkt.delay such that across all RX serving FUs' outport assert EOT signal in same clock cycle, which means in this case, eot isn't ever asserted leaving the RX hanging.

#### Where is it?
Module: Outport Mux

File: htax_outport_data_mux.v

Line number(s): 43

#### How to reproduce:
The bug is caught by the assertion which checks if rx_eot is asserted within the 1000cycle threshold of rx_sot being asserted. To achieve this, we can start firing packets in parallel on all RX ports such that their end of transfer is asserted in the same cycle.

#### Expected behavior:
Regardless of anything, eot should be asserted withing last data transfer cycles to RX.

#### Actual behavior:
EOT in RX isn't asserted if EOT is to be asserted on all RX FUs in same cycle.

#### Bug fix:
Looking at the logic written in line 43, htax_outport_data_mux.v which selects the eot wire, the condition "~(&(eot_in)" which is kept in AND with "|(eot_in & inport_sel_reg)" is causing the bug. Simple fix is to remove it, i.e. assign selected_eot = |(eot_in & inport_sel_reg);.

#### Failing Assertion:
![alt text](image-15.png)

#### Failing Scenario Waveform:
![alt text](image-16.png)
#### Failing Assertion Passing after the fix:
![alt text](image-14.png)

