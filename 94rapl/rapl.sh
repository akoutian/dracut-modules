#!/bin/sh

# Set CPU power limits using the intel-rapl sysfs interface. The values are
# specific to the ThinkPad T420 and the Intel i7-3940XM CPU. The reason for
# doing this is that the default limits are too high for the power circuits of
# the T420 motherboard, causing the Embedded Controller to forcibly lower CPU
# performance.

INTEL_RAPL_SYSFS_PKG_PATH='/sys/devices/virtual/powercap/intel-rapl/intel-rapl:0'

if [ ! -d ${INTEL_RAPL_SYSFS_PKG_PATH} ]
then
    echo "${0}: failed to find Intel RAPL sysfs interface"
    return 1
fi

CONSTRAINT_0_NAME='constraint_0'
CONSTRAINT_1_NAME='constraint_1'

POWER_LIMIT_SUFFIX='_power_limit_uw'
ENABLE_NAME='enabled'

INTEL_RAPL_PGK_PL1_CONTROL_PATH="${INTEL_RAPL_SYSFS_PKG_PATH}/${CONSTRAINT_0_NAME}${POWER_LIMIT_SUFFIX}"
INTEL_RAPL_PKG_PL2_CONTROL_PATH="${INTEL_RAPL_SYSFS_PKG_PATH}/${CONSTRAINT_1_NAME}${POWER_LIMIT_SUFFIX}"
INTEL_RAPL_PKG_PL_ENABLE_PATH="${INTEL_RAPL_SYSFS_PKG_PATH}/${ENABLE_NAME}"

PL1_VALUE_MICROWATT=45000000
PL2_VALUE_MICROWATT=45000000

if [ -f ${INTEL_RAPL_PGK_PL1_CONTROL_PATH} ]
then
    echo ${PL1_VALUE_MICROWATT} > ${INTEL_RAPL_PGK_PL1_CONTROL_PATH}
else
    echo "${0} failed to find Intel RAPL PKG PL1 path"
    return 1
fi


if [ -f ${INTEL_RAPL_PKG_PL2_CONTROL_PATH} ]
then
    echo ${PL2_VALUE_MICROWATT} > ${INTEL_RAPL_PKG_PL2_CONTROL_PATH}
else
    echo "${0}: failed to find Intel RAPL PKG PL2 path"
    return 1
fi

if [ -f ${INTEL_RAPL_PKG_PL_ENABLE_PATH} ]
then
    echo 1 > ${INTEL_RAPL_PKG_PL_ENABLE_PATH}
else
    echo "${0}: failed to find Intel RAPL enable path"
    return 1
fi
