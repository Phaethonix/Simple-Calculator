calc_expression() {
    local expr
    expr=$(echo "$1" | sed -E 's/([0-9]+)V([0-9]+)/(\2^(1\/\1))/g')
    echo "$expr" | bc -l
}
while true; do
    out=$(yad --title="Calculator" --width=400 --height=150 --form \
          --field="" "" \
          --field="Calculate:BTN" 'bash -c "exit 0"' \
          --field="Results:TXT" "$results")
    ret=$?
    if [ $ret -ne 0 ]; then
        break
    fi

    IFS="|" read -r expression _ _ <<< "$out"

    if [ -z "$expression" ]; then
        continue
    fi

    r=$(calc_expression "$expression")

    results="$results
$expression=$r"
done
