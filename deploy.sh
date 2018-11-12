#! /bin/bash

docker build -t benlamm/multi-client:latest benlamm/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t benlamm/multi-server:latest benlamm/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t benlamm/multi-worker:latest benlamm/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push benlamm/multi-client:latest
docker push benlamm/multi-server:latest
docker push benlamm/multi-worker:latest

docker push benlamm/multi-client:$SHA
docker push benlamm/multi-server:$SHA
docker push benlamm/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=benlamm/multi-server:$SHA
kubectl set image deployments/client-deployment client=benlamm/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=benlamm/multi-worker:$SHA
