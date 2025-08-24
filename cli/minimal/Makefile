# **************************************************************************************
#
#									Very minimal makefile.
#
# **************************************************************************************

#
#		Path / Name of emulator.
#
EMULATOR = emu_linux_x64
#
#		64tass optios.
#
ASMOPTS = -b -w -x

#
#		Assemble the source
#
assemble:
	64tass test.asm $(ASMOPTS) -otest.xex -Ltest.lst
#
#		Run program without break.
#
run: assemble
	x65emu -q file=test.xex	

#
#		Run program and break on 65816 NOP ($EA)
#
runbrk: assemble
	x65emu -q file=test.xex break=EA
