#!/usr/bin/env bash

ceph-deploy install node-4 node-5 node-6
ceph-deploy --overwrite-conf mon create node-4 node-5 node-6
ceph-deploy disk zap node-4:sdb node-4:sdc node-5:sdb node-5:sdc node-6:sdb node-6:sdc
ceph-deploy osd create  node-4:sdb node-4:sdc node-5:sdb node-5:sdc node-6:sdb node-6:sdc
