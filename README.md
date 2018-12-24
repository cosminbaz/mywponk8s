# mywponk8s
## Login to docker or IBM Cloud Registry
```
ibmcloud cr login
```
or
```
docker login
```
## Build, tag and upload to IBM Cloud Registry the new Simple Site container:
```
cd dockerimagebuild
docker build -t simplesite .
docker image ls
docker tag simplesite:latest registry.ng.bluemix.net/mywpnamespace/simplesite:v0.1
docker image ls
docker push registry.ng.bluemix.net/mywpnamespace/simplesite:v0.1
```

## re/Deploy simplesite deployment
```
kubectl apply -f simplesite-depoloyment.yaml
```

## re/Create mysql password secret
```
kubectl create secret generic mysql-pass --from-literal=password=mypass###
```

## re/Deploy mysql deployment and service (one yaml)
```
kubectl apply -f mysql-deployment.yaml
```

## re/Deploy services
```
kubectl apply -f simplesite-service.yaml
kubectl apply -f wordpress-service.yaml
```

## Generate certificates
### Use certbot on a pod (https://certbot.eff.org/lets-encrypt/debianjessie-apache) to get certificates
```
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
sudo ./path/to/certbot-auto --apache
```

## Create secrets (see mycerts dir)
```
kubectl create secret tls mywptlssecret --key www.ibm.baz.ro.key.pem --cert www.ibm.baz.ro.crt.pem
```

## re/Deploy Ingress
```
kubectl apply -f myingress.yaml
```

## Check how the Ingress redirects http to https and the 2 different pods based on URL path
<p>http://www.ibm.baz.ro
<p>http://www.ibm.baz.ro/info

