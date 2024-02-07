#!/bin/bash

# SPDX-License-Identifier: GPL-3.0-or-later

# Set programmable turbo boost ratio limits via MSR if supported.

# Corresponds to x39/x40/x41/x41 multiplier for 4/3/2/1 active cores respectively.
LIMITS=0x27282929

MSR_PLATFORM_INFO=0xce
MSR_TURBO_RATIO_LIMIT=0x1ad
MSR_PLATFORM_INFO_PRL_BIT=28

MSR_PLATFORM_INFO_PRL_ENABLED=$(rdmsr ${MSR_PLATFORM_INFO} -f ${MSR_PLATFORM_INFO_PRL_BIT}:${MSR_PLATFORM_INFO_PRL_BIT})

if [ -z ${MSR_PLATFORM_INFO_PRL_ENABLED} ]
then
    echo "${0} failed to read bit ${MSR_PLATFORM_INFO_PRL_BIT} from MSR ${MSR_PLATFORM_INFO}"
    return 1
fi

if [ ${MSR_PLATFORM_INFO_PRL_ENABLED} -eq 1 ]
then
    wrmsr -a ${MSR_TURBO_RATIO_LIMIT} ${LIMITS}
else
    echo "${0}: programmable ratio limit for Turbo Mode is disabled; failed to set ratio limits"
fi
