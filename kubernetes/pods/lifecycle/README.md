## Send Slack Messages On a K8s Container Lifecycle Event

This page contains a sample on how to define handlers that send Slack messages on a Kubernetes Container's `postStart` and `preStop` events/hooks.

A message is sent to a pre-defined Slack Webhook right after the Kubernetes pod is started (`postStart`) and right before the Pod is terminated (`preStop`).  

<img src="https://raw.githubusercontent.com/lsilvapvt/pcf-tools-belt/master/kubernetes/pods/lifecycle/slack_msg_container_hooks.png" alt="Slack" align="left" border=1 />


1. To get started, download [pods-lifecycle-hooks.yml](pods-lifecycle-hooks.yml) the sample configuration file for the Pod:  

```
apiVersion: v1
kind: Pod
metadata:
  name: lifecycle-hooks
spec:
  containers:
  - name: lifecycle-hooks-container
    image: bizongroup/alpine-curl-bash
    command: ["/bin/sh"]
    args: ["-c", "while true; do echo hello; sleep 5;done"]
    env:
    - name: SLACK_WEB_HOOK_URL
      value: "https://hooks.slack.com/services/..."  # < YOUR WEBHOOK URL GOES HERE
    lifecycle:
      postStart:
        exec:
          command: ["/bin/bash","-c","curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"Hello, World! From the postStart method.\"}' $SLACK_WEB_HOOK_URL"]  
      preStop:
        exec:
          command: ["/bin/bash","-c","curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"Goodbye, World! From the preStop method.\"}' $SLACK_WEB_HOOK_URL"]
```  

2. Before creating the pod, if not yet available, you need to create an Incoming Webhook on Slack by following these instructions: https://api.slack.com/incoming-webhooks . For experimentation purposes, you can set the `Post To` channel of the webhook to be your own slack ID (`@yourslackid`) or the `Slackbot`.

3. Once you have the Slack Incoming Webhook defined and enabled, copy its URL (e.g. `https://hooks.slack.com/services/T0000000ASDFASDFASDFASFD`) and replace it as the value for the `SLACK_WEB_HOOK_URL` environment variable entry in the Pod definition file.

4. Create the pod with the updated Pod definition file:  

   `kubectl apply -f pods-lifecycle-hooks.yml`  

   As soon as the pod is created, a message should be sent to the configured Slack webhook.  

5. Delete the pod:   

   `kubectl delete -f pods-lifecycle-hooks.yml`  

    Right before the pod is deleted, a message should be sent to the configured Slack webhook.  

----

See [Kubernetes Container Lifecycle Hooks](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/) for more information on container hooks.

This sample was built as an enhancement to the [Attach Handlers to Container Lifecycle Events](https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/) exercise.
