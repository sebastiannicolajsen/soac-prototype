while read l; do
    echo -e "${l//\"/\\\"}" | terraform taint
done < $(terraform state list)
