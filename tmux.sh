starttmux() {
    hosts=$(cat)

    if [[ -z "$hosts" ]]
    then
        echo no hosts found
        return 1
    fi

    first=`echo $hosts | cut -f1 -d " "`
    remaining=`echo $hosts | cut -f2- -s -d " "`

    tmux new-window "ssh $first"

    for h in $remaining
    do
        tmux split-window -h "ssh $h"
        tmux select-layout tiled > /dev/null
    done

    tmux select-pane -t 0
    tmux set-window-option synchronize-panes on > /dev/null
}

# start multiple ssh connections splitted in panes
connect() {
    hosts=`aws ec2 describe-instances --instance-ids --filters Name=tag:Name,Values=$1 | jq '.Reservations[].Instances[].PublicDnsName'`
    echo $hosts | starttmux
}

