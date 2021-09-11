transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/jorda/Desktop/InstructionMemory {C:/Users/jorda/Desktop/InstructionMemory/AlteraROM.v}
vlog -sv -work work +incdir+C:/Users/jorda/Desktop/InstructionMemory {C:/Users/jorda/Desktop/InstructionMemory/InstructionMemory.sv}

