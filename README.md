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

## re/Create mysql password secret
```
kubectl create secret generic mysql-pass --from-literal=password=mypass###
```

## re/Deploy mysql deployment and service (one yaml)
```
kubectl apply -f wordpress-mysql-service-and-deployment.yaml
```

## re/Deploy wordpress-deployment and the pvc included claim
```
kubectl apply -f wordpress-deployment.yaml
```

## re/Deploy simplesite deployment
Check that the new built image tag matches the tag in the yaml file
```
kubectl apply -f simplesite-depoloyment.yaml
```

## re/Deploy services
```
kubectl apply -f simplesite-service.yaml
kubectl apply -f wordpress-service.yaml
```

## (Optional, do only the first time) Generate certificates
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
http://www.ibm.baz.ro <br />
http://www.ibm.baz.ro/pod2

## Domain and certificates
### Domain
Any domain or subdomain can be used, the only important configuration is to point the NS of the domain/subdomain to the ibm cloud provided nameservers (e.g ns005.name.cloud.ibm.com).

- create the CIS in the right resource group from the IBM Cloud Web Console Account
- add the domain and the IBM Cloud NSs will be provided
- configure the domain/subdomain (at the Registrar level) to point to the above provided NSs
- create a CNAME record that will point to the Ingress subdomain of your cluster (e.g. mywpk8scluster1.us-south.containers.appdomain.cloud)
- configure ingress to point to the new domain (we go http only for now)
- the next 2 steps of the procedure will be automated at some point (this applies to Let's Encrypt Free certs only):
	- create a certbot pod (webserver + certbot script) that will listen to port 80, a corespondend service and a record in the Ingress that will respond to the new domain requests (see myingress.yaml), comment out redirect-to-https in the ingress (the pod only listens to 80 not 443)<br />

	(pull an image from here: ```docker pull cgbaz/certbot:v1```)<br />

	- generate new certificates and extract them in pem format
- having the new pem files (key & cert) certificates generate new secret:
```
kubectl create secret tls mywptlssecret --key new.site.key.pem --cert new.site.cert.pem
```
- update the myingress.yaml and re/deploy











