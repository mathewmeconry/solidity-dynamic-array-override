touch logs
nohup anvil --block-time 2 -a 2 --disable-default-create2-deployer --balance 300 --mnemonic "album syrup crisp legal dinner artwork prize canyon diesel clown album quick" > logs 2> logs &
sleep 10
forge script --chain sepolia --rpc-url http://127.0.0.1:8545 --broadcast -vvvv script/Deploy.s.sol
nohup yarn run start > logs 2> logs &
tail -f logs