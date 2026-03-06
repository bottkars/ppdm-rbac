this directory contains rbac files for ppdm
the files are:
- ppdm-controller-rbac.yaml
- ppdm-discovery.yaml
base on the git branch, the ressources in the rpac file need to be annotated with:
poverprotect.dell.com/version::{branch name}
the files need to pe uploaded and tagged to quay.io/delldps/ppdm-rbac:{branch name}
