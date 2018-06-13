function findFirstInstalled() {
  for i; do command -v "$i" >/dev/null && {
    echo "$i";
    return 0;
  };
  done;
  return 2;
}
