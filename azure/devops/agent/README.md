## Sample of self-hosted Azure DevOps agent as a container

The files in this folder were created after following instructions on how to run a self-hosted Linux Azure DevOps agent with Docker from this article:

https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux

---

### Run agent locally as a Docker image

To build a local docker image:
`docker build -t mydockeragent:latest .`

Sample commands to run agent locally as a Docker container:
```
export AZP_URL=<my_devops_url>   # e.g. https://dev.azure.com/myid123...
export AZP_TOKEN=<my_pat_token>   # see references below on how to create a PAT
export AZP_AGENT_NAME=mydockeragentname
docker run -e AZP_URL=${AZP_URL}  -e AZP_TOKEN=${AZP_TOKEN} -e AZP_AGENT_NAME=${AZP_AGENT_NAME} mydockeragent:latest
```

References:
- [How to create a Personal Access Token (PAT)](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page)

---

### Run agent as a container in a Kubernetes cluster

1. Build a docker image using the `Dockerfile` in this repository and then store it in a container registry (e.g. Docker Hub)

2. Create a namespace in your cluster and the secret for the PAT token
   `kubectl create namespace devops`
   `kubectl create secret generic azuredevops --from-literal=AZP_TOKEN=<your-pat-token-goes-here> -n devops`

3. Update [`azure-devops-agent.yml`](./azure-devops-agent.yml) with the image location from the step above, replacing entry `silval/azure-devops-agent:latest`. 

4. Deploy it to Kubernetes.
   `kubectl apply -f azure-devops-agent.yml`

5. Inspect the logs for the created pod and check if agent is ready (`Listening for Jobs`).
   `kubectl get pods -n devops`
   `kubectl logs <pod-name-from-output-of-cmd-above>`

If container is initialized correctly, it should be listed in the Azure DevOps panel (Azure DevOps > Organization Settings > Agent Pools > Default).

#### Note: 
If you plan to build Docker images using this agent running as a Kubernetes container, then you need to have the Docker deamon running as part of that container. 

Thus, for that scenario, instead of `azure-devops-agent.yml`, use on of the two alternative kubernetes deployment files below:

- [`azure-devops-agent-with-docker-daemon.yml`](./azure-devops-agent-with-docker-daemon.yml):  "Docker-in-Docker" approach, it runs the Docker daemon as a second [container](https://hub.docker.com/_/docker?tab=description&page=3&name=dind) in the same pod. This would be the preferred method from a secutiry standpoint.

- [`azure-devops-agent-with-docker-from-host.yml`](./azure-devops-agent-with-docker-from-host.yml): "Docker-out-of-Docker" approach, it runs with the Docker daemon from the host worker VM. 

For details, comparisons and the pros and cons of each approach, see this [article](https://medium.com/hootsuite-engineering/building-docker-images-inside-kubernetes-42c6af855f25).

---

To delete the Azure DevOps agent's container and namespace from the Kubernetes cluster:
   `kubectl delete -f azure-devops-agent.yml`
   `kubectl delete ns devops`

---