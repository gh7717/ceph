#!/usr/bin/env bash

ceph-deploy new node-1 node-2 node-3
ceph-deploy install node-1 node-2 node-3
ceph-deploy --overwrite-conf mon create-initial
ceph-deploy disk zap node-1:sdb node-1:sdc node-2:sdb node-2:sdc node-3:sdb node-3:sdc
ceph-deploy osd create  node-1:sdb node-1:sdc node-2:sdb node-2:sdc node-3:sdb node-3:sdc
