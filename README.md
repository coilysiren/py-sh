# py-sh

A static binary for during your shell grunt work in python

## Inspiration

I do a lot of lightweight work with `bash` + `coreutils`, and doing that work requires looking up at least one stackoverflow question essentially 100% of the time. This is more or less caused by `bash` + `coreutils` having very esoteric syntax, and not directly catering to the specific needs of engineers working on cli. So you end up having to do things like this

```bash
baseName=$1
baseName="$(tr '[:lower:]' '[:upper:]' <<< ${baseName:0:1})${baseName:1}"

adminProfileSuffix="AdminRole"
adminProfile="$baseName$adminProfileSuffix"
```

...
