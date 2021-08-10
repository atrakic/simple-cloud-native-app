#!/usr/bin/env bash

set -e
set -o pipefail
[[ -n $DEBUG ]] && set -x

app=${APP:-demo}
uri=${uri:-localhost}

main(){
  for i in $(seq 10);
  do
    HTTP_CODE=$(curl -sSL -o /dev/null -w "%{http_code}" --connect-timeout 5 "http://$uri")
    if [[ "$HTTP_CODE" == "200" ]] || [[ "$HTTP_CODE" == "302" ]];
    then
      res=$(
          curl -sSL -XGET \
            -H "Content-type: application/json" \
            http://"${uri}" | jq -S "length"
        )
      if [[ ${res} -gt 0 ]]; then
        echo "Success: $app with $res ..."
        exit 0
      else
        exit 1
      fi
    fi
    echo "Attempt $i to curl endpoint returned HTTP Code $HTTP_CODE."
    sleep 1
  done
}

main "$@"
