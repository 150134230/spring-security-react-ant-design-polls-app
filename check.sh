#!/bin/bash
opt=$1

check_sercet()
{
kubectl get secrets -n cyclone--system-tenant mysql-root-pass > /dev/null
if [ $? -eq 0 ];then
  echo "The secret mysql-root-pass is existing!!"
else
  kubectl -n cyclone--system-tenant mysql-user-pass create secret generic mysql-root-pass --from-literal=password=callicoder
fi


kubectl get secrets -n cyclone--system-tenant mysql-user-pass > /dev/null
if [ $? -eq 0 ];then
  echo "The secret mysql-user-pass is existing!!"
else
  kubectl -n cyclone--system-tenant mysql-user-pass create secret generic mysql-user-pass --from-literal=username=callicoder  --from-literal=password=c@ll1c0d3r  
fi

kubectl get secrets -n cyclone--system-tenant mysql-db-url > /dev/null
if [ $? -eq 0 ];then
  echo "The secret mysql-user-pass is existing!!"
else
  kubectl -n cyclone--system-tenant create secret generic mysql-db-url --from-literal=database=polls --from-literal=url=jdbc:mysql://polling-app-mysql:3306/polls?useSSL=false&serverTimezone=UTC&useLegacyDatetimeCode=false
fi
}

check_mysql_deployment()
{
kubectl get deployment polling-app-mysql -n cyclone--system-tenant
if [ $? -eq 0 ];then
  echo "The deployment mysql is existing!!"
else
  cd deployments
  kubectl apply -f mysql-deployment.yaml
fi
}

check_app()
{
#check server deployment whether is existing!
kubectl get -n cyclone--system-tenant polling-app-server > /dev/null
if [ $? -eq 0 ];then
  echo "The deployment server is existing!!"
else
  cd deployments
  kubectl apply -f polling-app-server.yaml
fi

#check client deployment whether is existing!
kubectl get -n cyclone--system-tenant polling-app-client > /dev/null
if [ $? -eq 0 ];then
  echo "The deployment client is existing!!"
else
  cd deployments
  kubectl apply -f polling-app-client.yaml
fi
}


case $opt in 
     sercet)
       check_sercet
       ;;
     mysql)
       check_mysql_deployment
       ;;
     app)
       check_app
       ;;
esac 
