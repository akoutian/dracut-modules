#!/bin/bash

# Limit processor package C-State to 2. Workaround for
# https://ticket.coreboot.org/issues/121. Requires MSR_PKG_CST_CONFIG_CONTROL
# to be unlocked in firmware. This unfortunately results in ~0.7W extra power
# consumption when idle. Ideally this will be resolved in the near future and
# this hook will be removed.

MSR_PKG_CST_CONFIG_CONTROL=0xe2
MSR_PKG_CST_CONFIG_CONTROL_LOCK_BIT=15

MSR_PKG_CST_CONFIG_CONTROL_LOCKED=$(rdmsr ${MSR_PKG_CST_CONFIG_CONTROL} -f ${MSR_PKG_CST_CONFIG_CONTROL_LOCK_BIT}:${MSR_PKG_CST_CONFIG_CONTROL_LOCK_BIT})

if [ -z ${MSR_PKG_CST_CONFIG_CONTROL_LOCKED} ]
then
    echo "${0}: failed to read MSR ${MSR_PKG_CST_CONFIG_CONTROL}; aborting"
    return 1
fi

if [ "${MSR_PKG_CST_CONFIG_CONTROL_LOCKED}" -eq 1 ]
then
    echo "${0}: processor package C-State config lock bit is set; failed to adjust C-State config"
    return 1
fi

# Corresponds to default value set by coreboot with the last 3 bits changed to 001.
MSR_PKG_CST_CONFIG_CONTROL_VALUE=$(rdmsr -c ${MSR_PKG_CST_CONFIG_CONTROL})
MSR_PKG_CST_CONFIG_CONTROL_VALUE=$((MSR_PKG_CST_CONFIG_CONTROL_VALUE | (1 << 0)))
MSR_PKG_CST_CONFIG_CONTROL_VALUE=$((MSR_PKG_CST_CONFIG_CONTROL_VALUE & ~(1 << 1)))
MSR_PKG_CST_CONFIG_CONTROL_VALUE=$((MSR_PKG_CST_CONFIG_CONTROL_VALUE & ~(1 << 2)))

wrmsr -a ${MSR_PKG_CST_CONFIG_CONTROL} ${MSR_PKG_CST_CONFIG_CONTROL_VALUE}
