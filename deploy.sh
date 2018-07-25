#!/bin/bash
set -u
source config.sh

cleanup() {
    echo 'Cleaning up'
    rm -f lambda.zip
}

create_zip() {
    echo 'Zipping lambda'
    zip --junk-paths -r lambda.zip src/
}

cleanup
create_zip
terraform apply \
    -var "region=us-east-1" \
    -var "profile_name=${profile_name}" \
    -var "domain_name=${domain_name}" \
    -var "pushover_token=${pushover_token}" \
    -var "pushover_userkey=${pushover_userkey}" \
    infra/
