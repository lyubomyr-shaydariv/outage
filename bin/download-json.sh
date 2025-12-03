set -TEeuo pipefail

declare -r CACHE_DIR="${1?no cache dir}"

declare -r CACHE="$CACHE_DIR/.schedule.json"

if [[ -e "$CACHE" ]]; then
	cat "$CACHE"
	exit
fi

mkdir --parents -- "$CACHE_DIR"

curl 'https://api.loe.lviv.ua/api/menus?page=1&type=photo-grafic' \
	| ifne tee "$CACHE"
