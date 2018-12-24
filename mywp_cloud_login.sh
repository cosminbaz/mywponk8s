#Connect to IBM Cloud:
#---------------------

#Create API for the IBM Account:
#GUI

#Log in to IBM Account:
ibmcloud login -a https://api.ng.bluemix.net --apikey "dQJ1lWEPzFfSDd2iLNZbz8C9d9btaBOmCcFfjSzFdZNY"

#Set Resource Group:
ibmcloud target -g mywpresourcegroup

#Set Region:
ibmcloud cs region-set us-south

#Login to Cloud Registry:
ibmcloud cr login

#Target Cloud functions:
ibmcloud target --cf

#Get Cluster Configuration ...
ibmcloud cs cluster-config mywpk8scluster1


#... Configure env for the cluster exporting the env kube variable
