# py-sh

A static binary for during your shell grunt work in python

## API Comparison

Right up front, here's the value proposition =>

```bash
# with bash / coreutils
baseName="$(tr '[:lower:]' '[:upper:]' <<< ${baseName:0:1})${baseName:1}"
adminProfileSuffix="AdminRole"
adminProfile="$baseName$adminProfileSuffix"

# with py-sh
adminProfile=$(echo $baseName | py-sh 'input.capitalize() + str(AdminRole)')
```

## Progression

`py-sh` version `1.0` is...

```
000.0%
```

...implemented. 

## Background

I do a lot of lightweight work with `bash` + `coreutils`, and doing that work requires looking up at least one stackoverflow question essentially 100% of the time. This is more or less caused by `bash` + `coreutils` having very esoteric syntax, and not directly catering to the specific needs of engineers working on cli. So you end up having to do things like this

```bash
baseName="lynn"
baseName="$(tr '[:lower:]' '[:upper:]' <<< ${baseName:0:1})${baseName:1}"
adminProfileSuffix="AdminRole"
adminProfile="$baseName$adminProfileSuffix"
echo $adminProfile # outputs "LynnAdminRole"
```

That took me two stackoverflow searches to create, and uses a lot of syntax and assumptions that are hard to explain to new engineers.

At the same time, I already know python. I know offhand that in python, the equivalent functionality could be written on the terminal as

```sh
baseName="lynn"
adminProfile=$(python -c "print('$baseName'.capitalize() + 'AdminRole')")
echo $adminProfile # outputs "LynnAdminRole"
```

I could create this with knowledge I had on hand! This is a nice boost to my iteration pace, is more readable for my future self, and uses syntax that you're very likely to see when doing other work in python.

It has a few fatal flaws, though. In order of increasing importance:

- There's still quote a bit of "shell invocation boilerplate", in the `'`, `"`, `-c`
- I intend to use this for infra / ops tasks, where you can't ensure that a particular python version will exist + be functional
- Its excuting a string (`$baseName`) as arbitrary python code, which produces infinitely many attack vectors

That sucks. But wait... those are all engineering problems, and maybe all problems that can be solved??? 

## The Goal

Spoiler: yes we can solve all those problems! We can create something that:

- Assumes its primary operating mode to be shell invocation (for the purpose of bash scripting)
- Includes a static linked python binary
- And treats its input strictly as a string

I'm calling that thing `py-sh`, and I want it to work like this

```sh
baseName="lynn"
adminProfile=$(echo $baseName | py-sh 'input.capitalize() + str(AdminRole)')
echo $adminProfile # outputs "LynnAdminRole"
```

## Prior Art

The overarching goal of `py-sh` is very similar to [xonsh](https://xon.sh/index.html), and [ipython shell](https://ipython.readthedocs.io/en/stable/interactive/shell.html). All 3 (`py-sh`, `xonsh`, `ipython shell`) aim to give users to ability to do "shell work" using python. The contrast significantly in their conceptual API though, `py-sh` is meant to be executed inside your existing shell (eg `bash`, `zsh`, etc) - and `xonsh` / `ipython shell` want to replace your shell.

- Finding out about `xonsh` is what originally inspired to author to start exploring this concept 🗺
- Adding support for ipython's concept of [magic commands](https://ipython.readthedocs.io/en/stable/interactive/magics.html) is currently under consideration 📝

The API of `py-sh` is functionally identical to [rb](https://github.com/thisredone/rb). The primary difference is in the implementation details, in that `py-sh` aims to ship itself as a binary that also contains a statically linked binary of its underlying language (eg. python).

- The idea to require api input be piped into `py-sh` was inspired by `rb` ✨
