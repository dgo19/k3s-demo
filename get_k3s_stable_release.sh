#!/bin/bash
curl https://update.k3s.io/v1-release/channels/stable | cut -d '"' -f2
exit 0
