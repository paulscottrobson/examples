# **************************************************************************************
#
#									Very minimal makefile.
#
# **************************************************************************************

EMULATOR = x65emu
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
	x65emu file=test.xex	

#
#		Run program and break on 65816 NOP ($EA)
#
runbrk: assemble
	x65emu file=test.xex break=EA
