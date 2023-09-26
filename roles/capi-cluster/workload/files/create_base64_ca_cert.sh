#!/bin/bash
# Copyright 2019 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# 	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

CAPO_SCRIPT=create_base64_ca_cert.sh
while test $# -gt 0; do
        case "$1" in
          -h|--help)
            echo "${CAPO_SCRIPT} - sources env vars for clusterctl init from an OpenStack clouds.yaml file"
            echo " "
            echo "source ${CAPO_SCRIPT} [options] <path/to/clouds.yaml> <cloud>"
            echo " "
            echo "options:"
            echo "-h, --help                show brief help"
            exit 0
            ;;
          *)
            break
            ;;
        esac
done

# Check if clouds.yaml file provided
if [[ -n "${1-}" ]] && [[ $1 != -* ]] && [[ $1 != --* ]];then
  CAPO_CLOUDS_PATH="$1"
else
  echo "Error: No clouds.yaml provided"
  echo "You must provide a valid clouds.yaml script to generate a cloud.conf"
  echo ""
  exit 1
fi

# Check if os cloud is provided
if [[ -n "${2-}" ]] && [[ $2 != -* ]] && [[ $2 != --* ]]; then
  export CAPO_CLOUD=$2
else
  echo "Error: No cloud specified"
  echo "You must specify which cloud you want to use."
  echo ""
  exit 1
fi

CAPO_YQ_TYPE=$(file "$(which yq)")
if [[ ${CAPO_YQ_TYPE} == *"Python script"* ]]; then
  echo "Wrong version of 'yq' installed, please install the one from https://github.com/mikefarah/yq"
  echo ""
  exit 1
fi

CAPO_CLOUDS_PATH=${CAPO_CLOUDS_PATH:-""}
CAPO_OPENSTACK_CLOUD_YAML_CONTENT=$(cat "${CAPO_CLOUDS_PATH}")

CAPO_YQ_VERSION=$(yq -V)
yqNavigating(){
        if [[ ${CAPO_YQ_VERSION} == *"version 1"* || ${CAPO_YQ_VERSION} == *"version 2"* || ${CAPO_YQ_VERSION} == *"version 3"* ]]; then
                yq r $1 $2
        else
                yq e .$2 $1
        fi
}

b64encode(){
  # Check if wrap is supported. Otherwise, break is supported.
  if echo | base64 --wrap=0 &> /dev/null; then
    base64 --wrap=0 $1
  else
    base64 --break=0 $1
  fi
}

# Just blindly parse the cloud.yaml here, overwriting old vars.
CAPO_CACERT_ORIGINAL=$(echo "$CAPO_OPENSTACK_CLOUD_YAML_CONTENT" | yqNavigating - clouds.${CAPO_CLOUD}.cacert)


# Build OPENSTACK_CLOUD_CACERT_B64
OPENSTACK_CLOUD_CACERT_B64=$(echo "" | b64encode)
if [[ "$CAPO_CACERT_ORIGINAL" != "" && "$CAPO_CACERT_ORIGINAL" != "null" ]]; then
  OPENSTACK_CLOUD_CACERT_B64=$(cat "$CAPO_CACERT_ORIGINAL" | b64encode)
fi
echo ${OPENSTACK_CLOUD_CACERT_B64}
