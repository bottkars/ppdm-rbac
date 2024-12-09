VELERO_PLUGIN=v1.5.3
BACKUP_DRIVER=v1.5.3
VELERO=v1.12.1
PPDM_RELEASE=19.18.0

DOCKER_SOURCE=harbor.pks.home.labbuildr.com/docker.io
DOCKER_TARGET=harbor.pks.home.labbuildr.com

i=14

    PPDM_BUILD=${PPDM_RELEASE}-$i
    echo "Pulling Images for ${PPDM_BUILD}"
    podman pull ${DOCKER_SOURCE}/dellemc/powerprotect-k8s-controller:${PPDM_BUILD} 
    podman pull ${DOCKER_SOURCE}/dellemc/powerprotect-cproxy:${PPDM_BUILD} 
    podman pull ${DOCKER_SOURCE}/dellemc/powerprotect-velero-dd:${PPDM_BUILD} 
    echo "Pushing Images for ${PPDM_BUILD}"
    podman push ${DOCKER_SOURCE}/dellemc/powerprotect-k8s-controller:${PPDM_BUILD} ${DOCKER_TARGET}/dellemc/powerprotect-k8s-controller:${PPDM_BUILD} 
    podman push ${DOCKER_SOURCE}/dellemc/powerprotect-cproxy:${PPDM_BUILD} ${DOCKER_TARGET}/dellemc/powerprotect-cproxy:${PPDM_BUILD} 
    podman push ${DOCKER_SOURCE}/dellemc/powerprotect-velero-dd:${PPDM_BUILD} ${DOCKER_TARGET}/dellemc/powerprotect-velero-dd:${PPDM_BUILD} 


echo "Pulling Velero Images"
podman pull ${DOCKER_SOURCE}/velero/velero:${VELERO} 
podman pull ${DOCKER_SOURCE}/vsphereveleroplugin/velero-plugin-for-vsphere:${VELERO_PLUGIN} 
podman pull ${DOCKER_SOURCE}/vsphereveleroplugin/backup-driver:${BACKUP_DRIVER}  

echo "Pushing Velero Images"
podman push ${DOCKER_SOURCE}/velero/velero:${VELERO} ${DOCKER_TARGET}/velero/velero:${VELERO} 
podman push ${DOCKER_SOURCE}/vsphereveleroplugin/velero-plugin-for-vsphere:${VELERO_PLUGIN} ${DOCKER_TARGET}/vsphereveleroplugin/velero-plugin-for-vsphere:${VELERO_PLUGIN} 
podman push ${DOCKER_SOURCE}/vsphereveleroplugin/backup-driver:${BACKUP_DRIVER}  ${DOCKER_TARGET}/vsphereveleroplugin/backup-driver:${BACKUP_DRIVER} 
