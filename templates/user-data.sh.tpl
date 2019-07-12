#!/bin/bash
set -x

# Setup logging
logfile="/tmp/install-ptfe.output"
exec > $logfile 2>&1


cat > /etc/replicated-ptfe.conf <<EOF
${tfe_config}
EOF

cat > /etc/replicated.conf <<EOF
${replicated_config}
EOF

cat > /tmp/replicated.rli.base64 <<EOF
${replicated_license}
EOF
base64 --decode /tmp/replicated.rli.base64 > /etc/replicated.rli

curl https://install.terraform.io/ptfe/stable > /tmp/ptfe-install.sh
chmod +x /tmp/ptfe-install.sh

sudo /tmp/ptfe-install.sh no-proxy private-address=${private_ip} public-address=${public_ip}
# | tee /tmp/install-ptfe.output

NOW=$(date +"%FT%T")
echo "[$NOW]  Sleeping for 5 minutes while PTFE installs."
sleep 300

while ! curl -ksfS --connect-timeout 5 https://${domain}/_health_check; do
    sleep 5
done

NOW=$(date +"%FT%T")
echo "[$NOW]  PTFE Instance is healthy"

NOW=$(date +"%FT%T")
echo "[$NOW]  Create initial site admin"
initial_token=$(replicated admin --tty=0 retrieve-iact)
curl -k \
  --header "Content-Type: application/json" \
  --request POST \
  --data '{"username":"${tfe_username}","email":"${tfe_email}","password":"${tfe_password}"}' \
  https://${domain}/admin/initial-admin-user?token=$${initial_token}

NOW=$(date +"%FT%T")
echo "[$NOW]  Finished PTFE user_data script."
