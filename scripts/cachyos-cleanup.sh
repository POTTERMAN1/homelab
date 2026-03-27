#!/bin/bash
echo "------- CACHY-OS CLEANUP -------"

capture_disk_usage() {
    local -n ref=$1
    while read -r used mount; do
        ref["$mount"]="$used"
    done < <(df --output=source,used,target -t btrfs -t ext4 | awk 'NR>1 && !seen[$1]++ {print $2, $3}')
}

declare -A before
capture_disk_usage before

declare -A after
capture_disk_usage after

echo "-------- CLEANUP SUMMARY --------"
for x in "${!before[@]}"; do
    usage_before=${before[$x]}
    usage_after=${after[$x]}
    gb_before=$(( usage_before / 1024 / 1024 ))
    gb_after=$(( usage_after / 1024 / 1024 ))
    space_saved=$(( gb_before - gb_after ))
    printf "%-10s - Before: %d GB | After: %d GB | Saved: %d GB\n" "$x" "$gb_before" "$gb_after" "$space_saved"
done