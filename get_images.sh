#!/bin/bash
VELERO=v1.18.0
DOCKER_SOURCE=docker.io
DOCKER_TARGET=quay.io/delldps
PPDM_RELEASE=20.2.0.0
for i in {14..14..1};
do
PPDM_BUILD=${PPDM_RELEASE}-$i
# PPDM_BUILD=20.1.0.0-1-SNAPSHOT

    podman pull ${DOCKER_SOURCE}/dellemc/powerprotect-k8s-controller:${PPDM_BUILD} --tls-verify=false 
    podman pull ${DOCKER_SOURCE}/dellemc/powerprotect-cproxy:${PPDM_BUILD} --tls-verify=false 
    podman pull ${DOCKER_SOURCE}/dellemc/powerprotect-velero-dd:${PPDM_BUILD} --tls-verify=false 

    podman push ${DOCKER_SOURCE}/dellemc/powerprotect-k8s-controller:${PPDM_BUILD} ${DOCKER_TARGET}/dellemc/powerprotect-k8s-controller:${PPDM_BUILD}
    podman push ${DOCKER_SOURCE}/dellemc/powerprotect-cproxy:${PPDM_BUILD} ${DOCKER_TARGET}/dellemc/powerprotect-cproxy:${PPDM_BUILD}
    podman push ${DOCKER_SOURCE}/dellemc/powerprotect-velero-dd:${PPDM_BUILD} ${DOCKER_TARGET}/dellemc/powerprotect-velero-dd:${PPDM_BUILD}
done


podman pull ${DOCKER_SOURCE}/velero/velero:${VELERO}
podman push ${DOCKER_SOURCE}/velero/velero:${VELERO} ${DOCKER_TARGET}/velero/velero:${VELERO}

