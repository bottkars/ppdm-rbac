#!/bin/bash
VELERO_PLUGIN=v1.5.4
BACKUP_DRIVER=v1.5.4
VELERO=v1.14.1
DOCKER_SOURCE=docker.io
DOCKER_TARGET=quay.io/delldps
PPDM_BUILD=19.22.0.24

podman pull ${DOCKER_SOURCE}/dellemc/powerprotect-k8s-controller:${PPDM_BUILD} --tls-verify=false 
podman pull ${DOCKER_SOURCE}/dellemc/powerprotect-cproxy:${PPDM_BUILD} --tls-verify=false 
podman pull ${DOCKER_SOURCE}/dellemc/powerprotect-velero-dd:${PPDM_BUILD} --tls-verify=false 

podman push ${DOCKER_SOURCE}/dellemc/powerprotect-k8s-controller:${PPDM_BUILD} ${DOCKER_TARGET}/dellemc/powerprotect-k8s-controller:${PPDM_BUILD}
podman push ${DOCKER_SOURCE}/dellemc/powerprotect-cproxy:${PPDM_BUILD} ${DOCKER_TARGET}/dellemc/powerprotect-cproxy:${PPDM_BUILD}
podman push ${DOCKER_SOURCE}/dellemc/powerprotect-velero-dd:${PPDM_BUILD} ${DOCKER_TARGET}/dellemc/powerprotect-velero-dd:${PPDM_BUILD}



podman pull ${DOCKER_SOURCE}/velero/velero:${VELERO}
podman pull ${DOCKER_SOURCE}/vsphereveleroplugin/velero-plugin-for-vsphere:${VELERO_PLUGIN}
podman pull ${DOCKER_SOURCE}/vsphereveleroplugin/backup-driver:${BACKUP_DRIVER} 


podman push ${DOCKER_SOURCE}/velero/velero:${VELERO} ${DOCKER_TARGET}/velero/velero:${VELERO}
podman push ${DOCKER_SOURCE}/vsphereveleroplugin/velero-plugin-for-vsphere:${VELERO_PLUGIN} ${DOCKER_TARGET}/vsphereveleroplugin/velero-plugin-for-vsphere:${VELERO_PLUGIN}
podman push ${DOCKER_SOURCE}/vsphereveleroplugin/backup-driver:${BACKUP_DRIVER}  ${DOCKER_TARGET}/vsphereveleroplugin/backup-driver:${BACKUP_DRIVER}
