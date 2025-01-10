# Step-by-Step Guide to Setting Up a Custom Kubernetes Cluster on AWS EC2

## **Step 1: Create EC2 Instances**
1. Launch an EC2 instance named **K8sMaster** with at least **4 GB RAM** and **2 vCPUs**.
2. SSH into the instance and run the following command to update the package list:
   ```bash
   sudo apt-get update
   ```
3. Create and run the `install.sh` script:
   ```bash
   vim install.sh
   ```
   Add the necessary commands to the script, then save and exit.
   ```bash
   sudo chmod +x install.sh
   ./install.sh
   ```
4. Repeat the same steps to create **Worker Nodes** (one or more, based on your requirements).

---

## **Step 2: Setup the Master Node**
We will use **Calico** as the network plugin. You can choose a different add-on if preferred.

Run the following command on the master node:
```bash
sudo kubeadm init \
  --apiserver-advertise-address=<API_ADDRESS_OF_MASTER_NODE> \
  --pod-network-cidr=192.168.0.0/16 \
  --service-cidr=10.96.0.0/12 \
  --cri-socket=/var/run/cri-dockerd.sock \
  --kubernetes-version=1.31.0
```

After successful initialization, you will get a join command similar to this:
```bash
kubeadm join 172.31.38.45:6443 --token g29t3l.eq2xrxsfoqua6f8k \
  --discovery-token-ca-cert-hash sha256:b1e1c2d6996694856796ef8898201cc3863713d0bea32ef2e622a27fa0f4428b
```
Modify the join command to include the CRI socket parameter:
```bash
sudo kubeadm join 172.31.38.45:6443 --token g29t3l.eq2xrxsfoqua6f8k \
  --discovery-token-ca-cert-hash sha256:b1e1c2d6996694856796ef8898201cc3863713d0bea32ef2e622a27fa0f4428b \
  --cri-socket unix:///var/run/cri-dockerd.sock
```
Run this modified command on all **Worker Nodes**.

---

## **Step 3: Configure the Master Node**
1. Set up the kubeconfig file:
   ```bash
   mkdir -p $HOME/.kube
   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
   sudo chown $(id -u):$(id -g) $HOME/.kube/config
   ```

2. Install **Calico** for networking:
   ```bash
   kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml
   kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml
   ```

3. Verify the nodes are ready:
   ```bash
   kubectl get nodes -o wide
   ```
   If nodes are not ready, wait a few minutes and run the command again.

---

## **Step 4: Deploy Your First Application**
1. Create a deployment file on the **Master Node**:
   ```bash
   vim deploy.yaml
   ```
   Add your deployment configuration to the file and save it.

2. Apply the deployment:
   ```bash
   kubectl apply -f deploy.yaml
   ```

3. Verify the deployment and pods:
   ```bash
   kubectl get pods -o wide
   kubectl get deployment deploy
   ```

4. Expose the deployment for external access:
   ```bash
   kubectl expose deployment nginx-deployment --type=NodePort --port=80
   ```

5. Get the service details:
   ```bash
   kubectl get svc
   ```

6. Find the public IP of the EC2 instance:
   ```bash
   curl http://checkip.amazonaws.com
   ```
   Access the application using the public IP and NodePort:
   ```
   http://<Public_IP>:31602
   ```

---

## **Step 5: Cleanup**
To uninstall and clean up the cluster, use the `uninstall.sh` script:
1. Create and run the script:
   ```bash
   vim uninstall.sh
   ```
2. Add the necessary cleanup commands, then save and exit.
   ```bash
   sudo chmod +x uninstall.sh
   ./uninstall.sh
   ```

3. Terminate the EC2 instances to complete the cleanup process.

---

**Congratulations!** You have successfully deployed your first application on a custom Kubernetes cluster using AWS EC2.

