FILES=$(git ls-files --cached | grep -E '^([^/]+|.*\/$)' -o | uniq)
DIR=$(git rev-parse --show-toplevel)

for file in $FILES; do
    sudo ln -sfv "${DIR}/${file}" "$HOME"
    echo ${DIR} ${file}
done;
