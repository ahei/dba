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
