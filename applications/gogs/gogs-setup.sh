#!/bin/sh
sleep 15
/bin/su git -c "/app/gogs/gogs admin create-user --name k3sdemo --password k3sdemo --email admin@example.com"
exit 0
