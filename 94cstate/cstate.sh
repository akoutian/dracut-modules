#!/bin/sh

# Limit processor package cstate to 2. Workaround for
# https://ticket.coreboot.org/issues/121. Requires MSR_PKG_CST_CONFIG_CONTROL
# to be unlocked in firmware. This unfortunately results in ~0.7W extra power
# consumption when idle. Ideally this will be resolved in the near future and
# this hook will be removed.

MSR_PKG_CST_CONFIG_CONTROL=0xe2

# corresponds to default value set by coreboot with the last 3 bits changed to 001
VALUE=0x1e008001

INITIAL_VALUE=$(rdmsr ${MSR_PKG_CST_CONFIG_CONTROL})

if [ -z "${INITIAL_VALUE}" ]
then
    echo "${0}: failed to read MSR ${MSR_PKG_CST_CONFIG_CONTROL}", aborting
    return 1
fi

wrmsr -a ${MSR_PKG_CST_CONFIG_CONTROL} ${VALUE}
