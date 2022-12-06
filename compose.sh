#!/bin/bash
#set -e

CONFIG_YML=()
OPTIONS=()
y=0
ARGUMENTS=( "$@" )

while [[ $y -lt ${#ARGUMENTS[@]} ]]
do
  	ARGUMENT=${ARGUMENTS[$y]}
  	case ${ARGUMENT} in
		up|build)
			CONFIG_YML+="-f docker-compose.yml"
			CMD="${ARGUMENT}"
			(( y++))
		;;
    --dev)
      CONFIG_YML+=" -f docker-compose.dev.yml"
      (( y++))
    ;;
		--restart-nginx)
			CMD="exec -it www nginx -s reload"
			(( y++))
		;;
    logs|config|ps|exec|down|images)
			CMD="${ARGUMENT}"
			(( y++))
		;;
		-d|-f|-it)
			OPTIONS+=("${ARGUMENT}")
			(( y++))
		;;
  		*)
  			(( y++))
  		;;
	esac
done
if (( ${#CONFIG_YML[@]} )); then
  docker-compose ${CONFIG_YML} ${CMD} ${OPTIONS}
else
  docker-compose ${CMD} ${OPTIONS}
fi
