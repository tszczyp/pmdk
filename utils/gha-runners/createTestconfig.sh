#!/usr/bin/env bash
# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2014-2022, Intel Corporation

#
#
#

# Default location for testconfig.sh
CONF_PATH="$(pwd)/src/test"
MOUNT_POINT="/mnt/pmem0"

#Create config file for unittests.
#We are using ndctl command to gather information about devdaxes, in form known from namespace configuration.
cat >${CONF_PATH}/testconfig.sh <<EOL
# main & local
PMEM_FS_DIR=${MOUNT_POINT}
DEVICE_DAX_PATH=($(ndctl list -X | jq -r '.[].daxregion.devices[].chardev' | awk '$0="/dev/"$0' | paste -sd' '))
KEEP_GOING=y
TM=5
UT_DUMP_LINES=1000
ENABLE_SUDO_TESTS=y
EOL

#Create config file for py tests.
#We are using ndctl command to gather information about devdaxes, in form known from namespace configuration.
cat >${CONF_PATH}/testconfig.py <<EOL
config = {
    'unittest_log_level': 1,
    'pmem_fs_dir': '${MOUNT_POINT}',
    'page_fs_dir': '/tmp/0',
    'fs': 'all',
    'cacheline_fs_dir': '${MOUNT_POINT}',
    'byte_fs_dir': '${MOUNT_POINT}',
    'force_cacheline': False,
    'force_page': False,
    'force_byte': True,
    'tm': True,
    'test_type': 'all',
    'build': 'all',
    'granularity': 'all',
    'fail_on_skip': False,
    'keep_going': True,
    'timeout': '30m',
    'fs_dir_force_pmem': 0,
    'dump_lines': 30,
    'force_enable': None,
    'device_dax_path' : [$(ndctl list -X | jq -r '.[].daxregion.devices[].chardev' | awk '$0="'\''/dev/"$0"'\''"' | paste -sd',')],
    'enable_admin_tests': True
}
EOL
