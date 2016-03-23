#include this into the main BoardConfig for autogenerated MR_REC_VERSION
#do not echo anything back to stdout, seems to bork stuff -_-

#if MR_REC_BUILD_NUMBER_FILE is not already defined, use the current path
ifeq ($(MR_REC_BUILD_NUMBER_FILE),)
# ${CURDIR}									full path to TOP
# $(dir $(lastword $(MAKEFILE_LIST)))		relative path to this file
MR_REC_BUILD_NUMBER_FILE := "$(dir $(lastword $(MAKEFILE_LIST)))MR_REC_BUILD_NUMBER-$(TARGET_DEVICE).TXT"
endif


#if the build number file doesnt exist create it as 01
$(shell if [ ! -f $(MR_REC_BUILD_NUMBER_FILE) ]; then echo 01 >$(MR_REC_BUILD_NUMBER_FILE); echo "Create MultiROM Recovery build number file" 1>&2; fi)

$(shell echo "MultiROM Recovery build number=`cat $(MR_REC_BUILD_NUMBER_FILE)`" 1>&2)

#once the recoveryimage is built, increase the build number for the next run
#if it's not the recoveryimage, then don't increase
recoveryimage:
	$(info Increase MultiROM Recovery build number)
	@build_num=`cat $(MR_REC_BUILD_NUMBER_FILE)`; \
	build_num=$$(( 10#$$build_num + 1 )); \
	if [ $$build_num -gt 99 ]; then \
		echo -ne "\nERROR: Build number will exceed 99 resetting to 01\n\n" 1>&2; \
		build_num=1; \
	fi; \
	printf "%02d" $$build_num >$(MR_REC_BUILD_NUMBER_FILE)


MR_REC_VERSION := $(shell date -u +%Y%m%d)-$(shell cat $(MR_REC_BUILD_NUMBER_FILE))
