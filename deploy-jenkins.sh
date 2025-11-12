#!/bin/bash
cd helm-projects
helm upgrade --install jenkins jenkinsci/jenkins --namespace jenkins --create-namespace -f jenkins-values.yaml
kubectl rollout restart statefulset/jenkins -n jenkins
kubectl scale statefulset/jenkins --replicas=0 -n jenkins
sleep 10
kubectl scale statefulset/jenkins --replicas=1 -n jenkins
kubectl get pods -n jenkins -o wide
echo "Jenkins ready at: $(minikube service jenkins -n jenkins --url)"
