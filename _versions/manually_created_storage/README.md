# Manually created Softlayer low cost (0.25IOPS/GB) Storage

This version was created with low cost storage, it will run very very very slow :)
The storage is attached both to wordpress pod (1) and to simplesite pod (2)
Before deploying check in each deployment yaml file the existance of the used images versions (v0.4 might not be actual and needs to be changed or retaged/reuploaded to IBM Cloud Registry)

## Configure persistent storage
### Needs
- wordpress-mysql (MySQL POD)
	- logs: /var/log/mysql (1G) 
	Note: uncomment log-error from /etc/mysql/mysql.conf.d/mysqld.cnf (line looks like: #log-error      = /var/log/mysql/error.log)
	- data: /var/lib/mysql (2G)
- wordpress (Main WebServer/Website)
	- logs: stdout / stderr (syntax example: /var/log/apache2/error.log -> /dev/stderr, /var/log/apache2/access.log -> /dev/stdout)	
	- content: /var/www/html (5G)

### Attach manually provided Softlayer Storage (0.25GB/IOPS - not included in any IBM K8s StorageClassNames, using that for lower costs) to K8s PV
- manually provide storage using Infrastructure Tab -> Storage -> FileStorage
- create or update a PV yaml: wordpress-pv_manuallyProvided.yaml

### Update wordpress-deployment yaml to claim storage in the manually provided and K8s attached PV

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
kubectl apply -f mysql-deployment.yaml
```

## re/Deploy wordpress-deployment and pvc included claim
```
kubectl apply -f wordpress-deployment.yaml
```

## re/Deploy simplesite deployment
```
kubectl apply -f simplesite-depoloyment.yaml
```

## re/Deploy services
```
kubectl apply -f simplesite-service.yaml
kubectl apply -f wordpress-service.yaml
```

## (Optional) Generate certificates
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
http://www.ibm.baz.ro
http://www.ibm.baz.ro/pod2
