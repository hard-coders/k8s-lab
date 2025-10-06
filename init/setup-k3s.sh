# Master 설치
echo "Installing K3s on master..."
multipass exec k3s-master -- bash -c "curl -sfL https://get.k3s.io | sh -"

# Master IP와 토큰 가져오기
MASTER_IP=$(multipass info k3s-master | grep IPv4 | awk '{print $2}')
NODE_TOKEN=$(multipass exec k3s-master -- sudo cat /var/lib/rancher/k3s/server/node-token)

echo "Master IP: ${MASTER_IP}"
echo "Waiting for master to be ready..."
sleep 15

# Worker 노드 조인
echo "Joining worker-1..."
multipass exec k3s-worker-1 -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=https://${MASTER_IP}:6443 K3S_TOKEN=${NODE_TOKEN} sh -"

echo "Joining worker-2..."
multipass exec k3s-worker-2 -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=https://${MASTER_IP}:6443 K3S_TOKEN=${NODE_TOKEN} sh -"

echo "Waiting for workers to join..."
sleep 1

# Kubeconfig 설정
mkdir -p ~/.kube
multipass exec k3s-master -- sudo cat /etc/rancher/k3s/k3s.yaml | sed "s/127.0.0.1/${MASTER_IP}/g" >~/.kube/config

echo ""
echo "K3s cluster is ready!"
