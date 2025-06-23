# 🛰️ Home Kubernetes Cluster

This repository contains configuration, manifests, and installation scripts to deploy and manage a secure Kubernetes cluster in a home lab environment. It is fully GitOps-friendly and organized for ease of automation and reproducibility.

---

## 📁 Directory Structure

```
k8s-cluster/
├── Calico/
│   ├── calico.yaml                # Calico CNI manifest
│   └── install-calico.sh          # Script to apply Calico
├── metallb/
│   ├── metallb-config.yaml        # IPAddressPool & L2Advertisement
│   └── install-metallb.sh         # Helm-based MetalLB installer
├── Downloads/
│   └── secure-k8s-node-setup.sh   # Secure node hardening script
└── README.md
```

---

## ⚙️ Cluster Details

- **Kubernetes Version**: `v1.30.14`
- **OS**: Ubuntu 24.04.2 LTS
- **Networking**: Calico (CNI)
- **LoadBalancer**: MetalLB on `192.168.12.50-192.168.12.250`
- **Control Planes**: `maia`, `electra`
- **Worker Nodes**: `taygete`, `celaeno`, `alcyone`, `sterope`, `merope`

---

## 🚀 Quick Start

1. **Install Calico**  
   ```bash
   cd Calico
   ./install-calico.sh
   ```

2. **Install MetalLB**
   ```bash
   cd ../metallb
   ./install-metallb.sh
   ```

3. **Verify**
   ```bash
   kubectl get nodes -o wide
   kubectl get svc
   ```

---

## 📦 Example Test Deployment

```bash
kubectl create deployment test-nginx --image=nginx
kubectl expose deployment test-nginx --port=80 --type=LoadBalancer
```

This will provision a LoadBalancer IP from MetalLB in the `192.168.12.0/24` VLAN range.

---

## 🔐 Security

- SSH keys used for Git access.
- Calico for network policies.
- Nodes are hardened with `secure-k8s-node-setup.sh`.
- All YAML is declarative and version-controlled.

---

## 🧱 Goals

- [x] GitOps-based infrastructure management
- [x] Automated network and load balancer setup
- [ ] TLS and Cert-Manager (next)
- [ ] Velero for backup and restore
- [ ] Monitoring with Prometheus & Grafana

---

## ✍️ Author

**Richard Edwards**  
 NORTHCOM Support Engineer  
[GitHub](https://github.com/rwedwards)

---

## 📜 License

MIT License – Use freely, modify responsibly.
