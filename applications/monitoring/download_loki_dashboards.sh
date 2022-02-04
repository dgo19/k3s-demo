#!/bin/bash
LOKI_DASHBOARDS="13186 12611"

for DBID in ${LOKI_DASHBOARDS}; do
	curl -skf "https://grafana.com/api/dashboards/${DBID}/revisions/1/download" | sed '/-- .* --/! s/"datasource":.*,/"datasource": "loki",/g' | sed 's/pod_name/pod/g' | sed 's/container_name/container/g' > dashboard-${DBID}.json
	kubectl -n monitoring create configmap grafana-dashboard-${DBID} --dry-run=client -o yaml --from-file=dashboard-${DBID}.json | sed '/^metadata:.*/a \  labels:\n    grafana_dashboard: "1"' > templates/configmap-dashboard-${DBID}.yaml
done
