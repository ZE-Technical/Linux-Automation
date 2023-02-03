# Building an RKE2 Environment with High-Availability for Rancher

**Prerequisits**
 - 3 Linux Nodes for Kubernetes
 - 1 Network Load Balancer
 - A DNS Record

Note that in order for RKE2 to work correctly with the load balancer, you need to set up two listeners: one for the supervisor on port 9345, and one for the Kubernetes API on port 6443.

Rancher needs to be installed on a supported Kubernetes version. To find out which versions of Kubernetes are supported for your Rancher version, refer to the support maintenance terms. To specify the RKE2 version, use the INSTALL_RKE2_VERSION environment variable when running the RKE2 installation script.

**RKE2 Specific Requirements**

RKE2 bundles its own containerd packages so Docker isn't needed before installation 