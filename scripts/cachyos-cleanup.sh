#!/bin/bash

# Check if the user is root

if [[ ${EUID} -eq 0 ]]; then
	echo "Don't run this script as root. It uses sudo where needed."
	exit 1
fi

echo "------- CACHY-OS CLEANUP -------"

# capture disk usage before the cleanup on btrfs/ext4 mounts

capture_disk_usage() {
	local -n ref=$1
	local df_output
	# trunk-ignore(shellcheck/SC2312)
	df_output=$(df --output=source,used,target -t btrfs -t ext4 | awk 'NR>1 && !seen[$1]++ {print $2, $3}')

	if [[ -z ${df_output} ]]; then
		echo "Warning: Failed to capture disk usage."
		return 1
	fi

	while read -r used mount; do
		# shellcheck disable=SC2034
		ref["${mount}"]="${used}"
	done <<<"${df_output}"
}

remove_orphaned_packages() {

	local orphans
	orphans=$(pacman -Qdtq)

	if [[ -z ${orphans} ]]; then
		echo "No orphaned packages found."
	else

		local count
		count=$(echo "${orphans}" | wc -l)
		echo "Found ${count} orphaned packages. Removing..."
		echo "${orphans}" | sudo pacman -Rns --noconfirm -
		echo "Orphaned packages removed."
	fi
}

paccache_cleanup() {

	echo "Pacman cache cleanup..."

	local paccache
	paccache=$(command -v paccache)
	if [[ -z ${paccache} ]]; then
		echo "Command paccache is not found."
	else

		local cached
		cached=$(sudo paccache -rk2)
		echo "${cached}"

		local cached_u
		cached_u=$(sudo paccache -ruk0)
		echo "${cached_u}"
	fi

}

aur_paru_cache_cleanup() {

	echo "AUR & PARU cache cleanup..."

	local aur_cache
	if [[ -d ~/.cache/yay ]]; then
		aur_cache=$(du -sh ~/.cache/yay)

		echo "Cleaning up AUR cache..."
		echo "${aur_cache}"

		rm -rf ~/.cache/yay/*
	else
		echo "No YAY cache found."
	fi

	local paru_cache

	if [[ -d ~/.cache/paru ]]; then
		paru_cache=$(du -sh ~/.cache/paru)

		echo "Cleaning up PARU cache..."
		echo "${paru_cache}"

		rm -rf ~/.cache/paru/*
	else
		echo "No PARU cache folder found."
	fi

}

snapper_cleanup() {
	echo "Snapper cleanup..."
	sudo snapper cleanup timeline
	sudo snapper cleanup number
	echo "Snapper cleanup complete."
}

journal_cleanup() {
	echo "Journal cleanup..."
	sudo journalctl --vacuum-size=200M
	echo "Journal cleanup complete."
}

declare -A before
capture_disk_usage before

remove_orphaned_packages
paccache_cleanup
aur_paru_cache_cleanup
snapper_cleanup
journal_cleanup

declare -A after
capture_disk_usage after

echo "-------- CLEANUP SUMMARY --------"
for x in "${!before[@]}"; do
	usage_before="${before[${x}]}"
	usage_after="${after[${x}]}"
	gb_before=$((usage_before / 1024 / 1024))
	gb_after=$((usage_after / 1024 / 1024))
	saved_kb=$((usage_before - usage_after))
	saved_mb=$((saved_kb / 1024))
	printf "%-15s — Before: %d GB | After: %d GB | Saved: %d MB\n" "$x" "$gb_before" "$gb_after" "$saved_mb"
done
