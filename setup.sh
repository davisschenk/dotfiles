FILES=$(git ls-files --cached | grep -E '^([^/]+|.*\/$)' -o | uniq)
DIR=$(git rev-parse --show-toplevel)

for file in $FILES;
    do ln -sv "${DIR}/${file}" "~/${file}"
done;
