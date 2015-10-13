#!/bin/bash
ceph osd pool create cache 128
ceph osd pool set cache size 1
ceph osd pool set cache crush_ruleset 1
ceph osd tier add rbd cache
ceph osd tier cache-mode cache writeback
ceph osd tier set-overlay rbd cache
