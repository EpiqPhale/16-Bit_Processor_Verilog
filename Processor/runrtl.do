# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./testProcessor.sv"
vlog "./Processor.sv"
vlog "./Control_Unit.sv"
vlog "./Datapath.sv"
vlog "./IR.sv"
vlog "./Mux2_to_1.sv"
vlog "./InstructionMemory.sv"
vlog "./AlteraROM.v"
vlog "./Data_Memory.sv"
vlog "./AlteraDmem.v"
vlog "./PC.sv"
vlog "./FSM.sv"
vlog "./ALU.sv"
vlog "./Register.sv"

# Callvlog "./InstructionMemory/InstructionMemory.sv" vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L work -L work -voptargs="+acc" -fsmdebug  testProcessor

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
