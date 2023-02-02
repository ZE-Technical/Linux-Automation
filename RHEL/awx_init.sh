# Initialize AWX (Ansible Tower) on RHEL/Rocky/Alma/CentOS
#
# Link used to build script:
# https://computingforgeeks.com/install-and-configure-ansible-awx-on-centos/
#
dnf -y update
dnf iy upgrade
# Disable Firewalld for K3s
systemctl diable firewalld --now
reboot
# Put SELinux in permissive mode
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config
cat /etc/selinux/config | grep SELINUX=
# Install K3s 
curl -sfL https://get.k3s.io | sudo bash -
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
# Check K3s service to verify it's running
systemctl status k3s.service
# Validate use of kubctl as root
#sudo su -
kubectl get nodes
# Confirm Kubernetes version
kubectl version --short
# Install git and make tools
dnf -y install git make
# Clone AWX Operator repo
git clone https://github.com/ansible/awx-operator.git
# Create namespace where AWX Operator will be deployed
export NAMESPACE=awx
kubectl create ns ${NAMESPACE}
# Set context to value 
kubectl config set-context --current --namespace=$NAMESPACE
# Switch to AWX Operator directory
cd awx-operator/
#
dnf -y install jq
RELEASE_TAG=`curl -s https://api.github.com/repos/ansible/awx-operator/releases/latest | grep tag_name | cut -d '"' -f 4`
echo $RELEASE_TAG
#
git checkout $RELEASE_TAG
export NAMESPACE=awx
make deploy
# Wait 2 minutes and verify that AWX Operator is running
kubectl get pods -n awx
#
vi public-static-pvc.yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: public-static-data-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-path
  resources:
    requests:
      storage: 5Gi
# Apply configuration manifest
kubectl apply -f public-static-pvc.yaml -n awx
#
kubectl get pvc -n awx
# C
file_to_create="awx-instance-deployment.yml"

echo "---
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx
spec:
  service_type: nodeport
  projects_persistence: true
  projects_storage_access_mode: ReadWriteOnce
  web_extra_volume_mounts: |
    - name: static-data
      mountPath: /var/lib/projects
  extra_volumes: |
    - name: static-data
      persistentVolumeClaim:
        claimName: public-static-data-pvc" > $file_to_create
# Install AWX
kubectl apply -f awx-instance-deployment.yml -n awx
# After 2 minutes check pod creation status
watch kubectl get pods -l "app.kubernetes.io/managed-by=awx-operator" -n awx
# Track installation process
#kubectl logs -f deployments/awx-operator-controller-manager -c awx-manager
#
kubectl  get pvc
# Provide Container name
kubectl -n awx  logs deploy/awx -c redis
kubectl -n awx  logs deploy/awx -c awx-web
kubectl -n awx  logs deploy/awx -c awx-task
kubectl -n awx  logs deploy/awx -c awx-ee
# Access AWX Web Interface
kubectl get service -n awx
# View admin password
kubectl -n awx get secret awx-admin-password -o go-template='{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}'
