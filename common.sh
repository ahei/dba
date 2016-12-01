version()
{
    echo "${PROGRAM_NAME} ${PROGRAM_VERSION}"
    exit 1
}

# echo to stderr
echoe()
{
    printf "$*\n" 1>&2
}

executeCommand()
{
    local _command="$1"
    local _isExecute="$2"
    local _isQuiet="$3"
    local _isStop="$4"
    
    [ "$_isQuiet" != 1 ] && echo "Executing command \`${_command}' ..."
    if [ "${_isExecute}" != "0" ]; then
        eval "${_command}"
        if [ $? != 0 ]; then
            echoe "Execute command \`${_command}' failed."
            if [ "$_isStop" = 1 ]; then
                exit 1
            fi
        fi
    fi
}

joinPath()
{
    local path="$1"
    local name="$2"

    if [[ "${path:-1:1}" = "/" ]]; then
        echo "${path}${name}"
    else
        echo "${path}/${name}"
    fi
}

normalizePath()
{
    local path="$1"

    if [ -d "$path" ]; then
        echo "$(cd $path && pwd)"
        return
    fi

    local dir=$(dirname "$path")
    local basename=$(basename "$path")

    if [ -r "$dir" ]; then
        dir="$(cd $dir && pwd)"
    fi

    if [[ "$basename" != "." ]]; then
        path="$(joinPath $dir $basename)"
    else
        path="$dir"
    fi

    echo "$path"
}

# $1: path
toAbsPath()
{
    local path="$1"
    if [ "${path:0:1}" != "/" ]; then
        path=$(pwd)/"$path"
    fi

    normalizePath "$path"
}

isIp()
{
    local ip=$1
    grep -q -E "([0-9]{1,3}\.){3}[0-9]{1,3}" <<< "$ip"
}

ip2Host()
{
    local ip=$1
    local host=$(host $ip)

    if ! isIp "$ip"; then
        echo "$ip"
        return
    fi
    
    if grep -q "not found" <<< "$host"; then
        echo $ip
    else
        echo $host | awk '{print $ NF}' | sed 's/.$//g'
    fi
}

# $1: pattern
# $2: month
# $3: day
# $4: hour
getTimeStr()
{
    local pattern=$1
    local month=$2
    local day=$3
    local hour=$4
    local timeStr="$pattern"
    
    if (( month < 0 )); then
        month=$(date -d "$((-month)) months ago" +%m)
        month=${month#0}
    fi
    if (( day < 0 )); then
        if [ ! "$month" ]; then
            month=$(date -d "$((-day)) days ago" +%m)
            month=${month#0}
        fi
        day=$(date -d "$((-day)) days ago" +%d)
        day=${day#0}
    fi
    if [ "$hour" != '*' ] && (( hour < 0 )); then
        hour=$(printf "%1d" $(date -d "$((-hour)) hours ago" +%k))
    fi
    
    if [ "$month" ]; then
        timeStr=$(sed -r "s/%m/$(printf %02d $month)/g" <<< "$timeStr")
    fi
    if [ "$day" ]; then
        timeStr=$(sed -r "s/%d/$(printf %02d $day)/g" <<< "$timeStr")
        timeStr=$(sed -r "s/%e/$(printf %2d $day)/g" <<< "$timeStr")
    fi
    if [ "$hour" ] ; then
        if [ "$hour" != '*' ]; then
            timeStr=$(sed -r "s/%H|%I/$(printf %02d $hour)/g" <<< "$timeStr")
            timeStr=$(sed -r "s/%k|%l/$(printf %2d $hour)/g" <<< "$timeStr")
        else
            timeStr=$(sed -r "s/%H|%I/$hour/g" <<< "$timeStr")
            timeStr=$(sed -r "s/%k|%l/$hour/g" <<< "$timeStr")
        fi
    fi

    timeStr=$(date +"$timeStr")
    echo -n "$timeStr"
}
