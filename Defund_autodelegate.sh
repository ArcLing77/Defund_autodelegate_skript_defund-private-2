#!/bin/bash
RED_COLOR='\033[0;31m'
WITHOU_COLOR='\033[0m'
DELEGATOR_ADDRESS='YOU_ADDRESS'
VALIDATOR_ADDRESS='YOU_VOLOPER'
DELAY=60*1 #in secs - how often restart the script 
WALLET_NAME=wallet #example: = WALLET_NAME=wallet_qwwq_54
#NODE="tcp://localhost:26657" #change it only if you use another rpc port of your node

for (( ;; )); do
        echo -e "Get reward from Delegation"
        echo "YOU_PASSWORD" | defundd tx distribution withdraw-rewards ${VALIDATOR_ADDRESS} --from ${WALLET_NAME} --chain-id defund-private-2 --fees 500ufetf --commission -y
        for (( timer=30; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOUT_COLOR} sec\r" $timer
                sleep 1
        done
 
#        BAL=$(defundd query bank balances ${DELEGATOR_ADDRESS} --chain-id defund-private-2 | awk '/amount:/{print $NF}' | tr -d '"')
        BAL=$(defundd query bank balances ${DELEGATOR_ADDRESS} --chain-id defund-private-2 --output json | jq -r '.balances[] | select(.denom=="ufetf")' | jq -r .amount)
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} ufetf\n"

       
        BAL=$(defundd query bank balances ${DELEGATOR_ADDRESS} --chain-id defund-private-2 --output json | jq -r '.balances[] | select(.denom=="ufetf")' | jq -r .amount)
#        BAL=$(defundd query bank balances ${DELEGATOR_ADDRESS} --chain-id defund-private-2 | awk '/amount:/{print $NF}' | tr -d '"')
        BAL=$(($BAL-50000))
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} ufetf\n"
        echo -e "Stake ALL 11111\n"
        if (( BAL > 900000 )); then
        echo "YOU_PASSWORD" | defundd tx staking delegate ${VALIDATOR_ADDRESS} ${BAL}ufetf --from ${WALLET_NAME} --chain-id defund-private-2 --fees 1000ufetf --yes
        else
          echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} ufetf BAL < 900000 ((((\n"
        fi 
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
                sleep 1
        done       

done