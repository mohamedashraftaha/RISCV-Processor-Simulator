CSCE330 Project Milestone4 (Final Milestone)




Team Members:
1.  Mohamed Ashraf Taha
       900172754
2.   Omar Sherif Mahdy
       900160493




1.  How to run Simulation:
1. To RUN pipelined processor
   I. Choose our testbench for the top module Riscv_tb as a top module
   II. Make sure that the called module is Full_Datapath.
   III. Click on run behavioural simulation
   IV. The simulation wave window will only contain clk and rst, then we need to add the full datapath in to the wave window by clicking add to wave window
   V. Then relaunch the simulation
   VI. The simulation will not show all the clock cycles but to do so, so we need to click on the blue play button “run all” to run for more clock cycles and show all instructions.
2. To RUN BONUS pipelined processor with Branch in Decoding stage
   I. Choose our testbench for the top module Riscv_tb as a top module
   II. Make sure that the called module is FullDatapath_BONUS
   III. Click on run behavioural simulation
   IV. The simulation wave window will only contain clk and rst, then we need to add the full datapath in to the wave window by clicking add to wave window
   V. Then relaunch the simulation
   VI. The simulation will not show all the clock cycles but to do so, so we need to click on the blue play button “run all” to run for more clock cycles and show all instructions.




2. Issues that we came across in this MS:
   I. In testing we faced the problem of converting the hex to machine code from the oak website, as we should take the inverse order, from right to left, of the hex appearing in the output window and then copy it into another website to convert it to binary 32 bits, so it was prone to a lot of errors, but we managed to double check all the binary machine codes and use RARS simulator to generate the hex code instead of Oak website.


   II. We faced a lot of errors with the clock, since sometimes register values that we wanted were delayed by one clock cycle, so we had to adjust the clock and the modules’ behaviour to be fully functional.


   III. We implemented the BONUS part of moving the branch outcome to the decode stage in a separate module so that if it wasn't working correctly, it will not affect our original implementation of the RISC_V processor.


   IV. We also faced a problem of keeping up with the number of bits of each register or wires, especially that we had to change the top module a lot in order to cope with all kinds of hazards and to support all functions of the RISC V processor. 
        
   V. We some times passed the wrong inputs to the modules due to some similarities in the names of the modules that we were able to cope with and debug very carefully to make sure that there is no wire that is not connected, or any register that incorrect number of bits.  


   
3. Assumptions that we made
   We assumed that some of the wires or registers should be available at certain clock cycles, so we adjusted these registers or wires so that each of them should appear in the correct clock cycle and do not affect the functionality of other instructions. Some of the registers appear on the negative edge of the clock, and others appear on the positive edge of the clock depending on our understanding of the processor and the module itself.
  
4. What works
   I. All instructions are fully functioning and working with correct outputs.
   
   II. The BONUS part: 
1. The mul,div and rem instructions with all their sub instructions are working functionality and produce correct outputs
2. Moving the branch outcome to the decode stage also is fully functioning and produce correct branching outputs in the correct locations. Also, we dealt with the forwarding hazards that may happen because of this change by instantiating new forwarding unit specialized in solving the errors after moving the branch outcome to be as early as in the decode stage.