## Sample of MS SQL Server deployment manifest

Sample of attempt to get MS SQL Server docker image running as a Kubernetes pod: https://hub.docker.com/_/microsoft-mssql-server

To test service after deployment:

`kubectl exec <mssql-pod-name> -n mssql -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P '<your_password>'`

*Note:* If password provided to the container is not strong enough, the SQL server will not start.
