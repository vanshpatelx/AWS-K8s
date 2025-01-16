kind create cluster --config kind-cluster.yaml --name my-cluster


kubectl get nodes


kubectl apply -f redis-configmap.yaml
kubectl apply -f redis-master-service.yaml
kubectl apply -f redis-master-statefulset.yaml
kubectl apply -f redis-slaves-service.yaml
kubectl apply -f redis-slaves-statefulset.yaml


kubectl delete -f redis-master-service.yaml
kubectl delete -f redis-master-statefulset.yaml
kubectl delete -f redis-slaves-service.yaml
kubectl delete -f redis-slaves-statefulset.yaml
kubectl delete -f redis-configmap.yaml


kubectl apply -f redis-sentinel-configmap.yaml
kubectl apply -f redis-sentinel-statefulset.yaml
kubectl apply -f redis-sentinel-service.yaml


kubectl delete -f redis-sentinel-configmap.yaml
kubectl delete -f redis-sentinel-statefulset.yaml
kubectl delete -f redis-sentinel-service.yaml


kubectl exec -it redis-sentinel-0 -- redis-server --sentinel /etc/redis/sentinel.conf



kubectl apply -f redis-configmap.yaml
kubectl apply -f redis-master-service.yaml
kubectl apply -f redis-slaves-service.yaml
kubectl apply -f redis-master-statefulset.yaml
kubectl apply -f redis-slaves-statefulset.yaml
kubectl apply -f redis-sentinel-statefulset.yaml


kubectl delete -f redis-configmap.yaml
kubectl delete -f redis-master-service.yaml
kubectl delete -f redis-slaves-service.yaml
kubectl delete -f redis-master-statefulset.yaml
kubectl delete -f redis-slaves-statefulset.yaml
kubectl delete -f redis-sentinel-statefulset.yaml




With HA Proxy

kubectl apply -f redis-master-statefulset.yaml
kubectl apply -f redis-slave-statefulset.yaml
kubectl apply -f ha-proxy-deployment.yaml
kubectl apply -f haproxy-config.yaml
kubectl apply -f service.yaml
kubectl apply -f ha-service.yaml


kubectl delete -f redis-master-statefulset.yaml
kubectl delete -f redis-slave-statefulset.yaml
kubectl delete -f ha-proxy-deployment.yaml
kubectl delete -f haproxy-config.yaml
kubectl delete -f service.yaml
kubectl delete -f ha-service.yaml
