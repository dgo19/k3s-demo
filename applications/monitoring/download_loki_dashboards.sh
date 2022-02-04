#!/bin/bash
set -x
LOKI_DASHBOARDS="12019,2"

for DBIDREV in ${LOKI_DASHBOARDS}; do
	DBID=$(echo ${DBIDREV} | cut -d "," -f1)
	DBREV=$(echo ${DBIDREV} | cut -d "," -f2)
	curl -skf "https://grafana.com/api/dashboards/${DBID}/revisions/${DBREV}/download" | sed '/-- .* --/! s/"datasource":.*,/"datasource": "loki",/g' | sed 's/pod_name/pod/g' | sed 's/container_name/container/g' > dashboard-${DBID}.json
	kubectl -n monitoring create configmap grafana-dashboard-${DBID} --dry-run=client -o yaml --from-file=dashboard-${DBID}.json | sed '/^metadata:.*/a \  labels:\n    grafana_dashboard: "1"' > templates/configmap-dashboard-${DBID}.yaml
	rm dashboard-${DBID}.json
done
