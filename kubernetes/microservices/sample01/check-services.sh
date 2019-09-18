#!/bin/bash 
echo "Checking return codes of microservices:"
max_timeout=2.0
while true
do
    dateinit=$(date +%H:%M:%S)
    catalog=$(curl --write-out "Catalog:(%{http_code}) %{time_total}" --silent --max-time ${max_timeout} --output /dev/null http://${API_ENDPOINT}/catalog)
    order=$(curl --write-out "Order:(%{http_code}) %{time_total}" --silent --max-time ${max_timeout} --output /dev/null http://${API_ENDPOINT}/order)
    customer=$(curl --write-out "Customer:(%{http_code}) %{time_total}" --silent --max-time ${max_timeout} --output /dev/null http://${API_ENDPOINT}/customer)
    webapp=$(curl --write-out "Webapp:(%{http_code}) %{time_total}" --silent --max-time ${max_timeout} --output /dev/null http://${API_ENDPOINT})
    echo "[${dateinit}] ${catalog}, ${order}, ${customer}, ${webapp}"
    sleep 0.5s
done    