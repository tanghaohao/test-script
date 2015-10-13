#/bin/bash
#for id in `seq 0 6`; do
	ceph tell osd.* injectargs "--filestore_min_sync_interval 1"
	ceph tell osd.* injectargs "--filestore_max_sync_interval 3"
	ceph tell osd.* injectargs "--filestore_queue_max_ops 819600000"
	ceph tell osd.* injectargs "--filestore_queue_max_bytes 819600000"
	ceph tell osd.* injectargs "--filestore_queue_committing_max_ops 819600000"
	ceph tell osd.* injectargs "--filestore_queue_committing_max_bytes 819600000"
#done
