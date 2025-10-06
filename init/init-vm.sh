IMAGE=24.04

echo "Install k3s with $IMAGE.."

multipass launch $IMAGE \
  --name k3s-master \
  --cpus 2 \
  --memory 2G \
  --disk 20G

multipass launch $IMAGE \
  --name k3s-worker-1 \
  --cpus 2 \
  --memory 4G \
  --disk 30G

multipass launch $IMAGE \
  --name k3s-worker-2 \
  --cpus 2 \
  --memory 4G \
  --disk 30G

# check vm list
multipass list
