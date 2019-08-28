
########Run commands in shell.azure.com unless specified#############

#Step 1 - kubernetes and helm

az group create -n k8sspoceastus -l eastus

PASSWORD_WIN="P@ssw0rd1234"

#default linux pool - this is needed to run helm 
az aks create --resource-group k8sspoceastus --name k8sspoceastus --node-count 1 --enable-addons monitoring --kubernetes-version 1.14.6 --generate-ssh-keys --windows-admin-password $PASSWORD_WIN --windows-admin-username azureuser --enable-vmss --network-plugin azure

#create windows pool
az aks nodepool add --resource-group k8sspoceastus --cluster-name k8sspoceastus --os-type Windows --name npwin --node-count 1 --kubernetes-version 1.14.6

az aks get-credentials -n k8sspoceastus -g k8sspoceastus

cat << EOF | kubectl apply -f - 
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
EOF

helm init --service-account tiller --node-selectors "beta.kubernetes.io/os"="linux"

#upload the values.yaml to shell.azure.com before execute the helm install command below

helm install stable/nginx-ingress --name nginxing -f values.yaml



#Step 2 - Docker image (run these commands in visual studio code)

az acr create --resource-group k8sspoceastus --name k8sspoceastusacr --sku Basic

az acr login --name k8sspoceastusacr

az acr list --resource-group k8sspoceastus --query "[].{acrLoginServer:loginServer}" --output table

docker tag mvcsspoc:dev k8sspoceastusacr.azurecr.io/mvcsspoc:v1

docker push k8sspoceastusacr.azurecr.io/mvcsspoc:v1


#Step 3 - Create namespace 

kubectl create ns stickyns1
kubectl create ns stickyns2
kubectl create ns stickyns3


#Step 4 - Deploy yaml

Deploy environment per namespace (see manifests/sticky1-3.yaml). Be aware: you have to change the HOST name for the ingress definitions to match your custom URL
Check: Hit the environments via http://<CUSTOM_URL>/stickyns1, http://<CUSTOM_URL>/stickyns1, http://<CUSTOM_URL>/stickyns1

Outcome: each customer gets its own dedicated environment, including sticky sessions.

kubectl apply -f sticky1.yaml
kubectl apply -f sticky2.yaml
kubectl apply -f sticky3.yaml


