VELERO_PLUGIN=v1.5.3
BACKUP_DRIVER=v1.5.3
VELERO=v1.12.1
# Example with docker proxy
# DOCKER_SOURCE=harbor.pks.home.labbuildr.com/docker.io
# example with Docker
DOCKER_SOURCE=quai.io/delldps
DOCKER_TARGET=harbor.pks.home.labbuildr.com
PPDM_RELEASE=19.19.0
for ((i = 14 ; i < 15 ; i++ ));
do
PPDM_BUILD=${PPDM_RELEASE}-$i
    podman pull ${DOCKER_SOURCE}/dellemc/powerprotect-k8s-controller:${PPDM_BUILD} 
    podman pull ${DOCKER_SOURCE}/dellemc/powerprotect-cproxy:${PPDM_BUILD} 
    podman pull ${DOCKER_SOURCE}/dellemc/powerprotect-velero-dd:${PPDM_BUILD} 

    podman push ${DOCKER_SOURCE}/dellemc/powerprotect-k8s-controller:${PPDM_BUILD} ${DOCKER_TARGET}/dellemc/powerprotect-k8s-controller:${PPDM_BUILD}
    podman push ${DOCKER_SOURCE}/dellemc/powerprotect-cproxy:${PPDM_BUILD} ${DOCKER_TARGET}/dellemc/powerprotect-cproxy:${PPDM_BUILD}
    podman push ${DOCKER_SOURCE}/dellemc/powerprotect-velero-dd:${PPDM_BUILD} ${DOCKER_TARGET}/dellemc/powerprotect-velero-dd:${PPDM_BUILD}
done


podman pull ${DOCKER_SOURCE}/velero/velero:${VELERO}
podman pull ${DOCKER_SOURCE}/vsphereveleroplugin/velero-plugin-for-vsphere:${VELERO_PLUGIN}
podman pull ${DOCKER_SOURCE}/vsphereveleroplugin/backup-driver:${BACKUP_DRIVER} 


podman push ${DOCKER_SOURCE}/velero/velero:${VELERO} ${DOCKER_TARGET}/velero/velero:${VELERO}
podman push ${DOCKER_SOURCE}/vsphereveleroplugin/velero-plugin-for-vsphere:${VELERO_PLUGIN} ${DOCKER_TARGET}/vsphereveleroplugin/velero-plugin-for-vsphere:${VELERO_PLUGIN}
podman push ${DOCKER_SOURCE}/vsphereveleroplugin/backup-driver:${BACKUP_DRIVER}  ${DOCKER_TARGET}/vsphereveleroplugin/backup-driver:${BACKUP_DRIVER}
