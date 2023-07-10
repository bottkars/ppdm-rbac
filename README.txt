# PPDM Controller's Service Accounts And RBAC Permissions

Set up the PPDM `discovery` service account and RBAC permissions:

```sh
kubectl apply -f ppdm-discovery.yaml 
```

Set up the PPDM `controller` service account and RBAC permissions:

```sh
kubectl apply -f ppdm-controller-rbac.yaml
```

For Kubernetes version 1.24+, create the secret for the 
`ppdm-discovery-serviceaccount` service account:

```sh
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ppdm-discovery-serviceaccount-token
  namespace: powerprotect
  annotations:
    kubernetes.io/service-account.name: ppdm-discovery-serviceaccount
type: kubernetes.io/service-account-token
EOF
```

Retrieve the base64-decoded service account token from the new secret:

```sh
kubectl -n powerprotect get secret ppdm-discovery-serviceaccount-token -ojsonpath='{.data.token}' | base64 -d -
```

Retrieve the cluster API endpoint:

```sh
kubectl cluster-info
```

In the PowerProtect Data Manager UI, add the Kubernetes cluster as an `Asset 
Source`, with the following properties:

* `FQDN/IP` - Cluster API endpoint retrieved using the `kubectl cluster-info` 
command
* `Host Credentials` - service account token retrieved from the 
`ppdm-discovery-serviceaccount-token` secret

Adding the cluster will initiate a cluster discovery operation. Once completed,
check that the PPDM controller and Velero are up and running.

Confirm that PPDM controller is successfully rolled out:

```sh
$ kubectl -n powerprotect rollout status deploy/powerprotect-controller
deployment "powerprotect-controller" successfully rolled out
```

Make sure the PPDM pods are running:

```sh
$ kubectl -n powerprotect get po
NAME                                       READY   STATUS    RESTARTS     AGE
powerprotect-controller-6b47f5fc8c-lsqsq   1/1     Running   2 (9d ago)   13d
```

Confirm that Velero is successfully rolled out:

```sh
$ kubectl -n velero-ppdm rollout status deploy velero
deployment "velero" successfully rolled out
```

In a vSphere setup, there will also be the `backup-driver` Velero plugin
workload.

Make sure the Velero pod is running:

```sh
$ kubectl -n velero-ppdm get po
NAME                             READY   STATUS    RESTARTS     AGE
velero-764cc9846d-2r786          1/1     Running   1 (9d ago)   13d
```
