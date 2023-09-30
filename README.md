# py-sh

A binary for during your shell grunt work in python

## Overview

Here's the value of `py-sh`, compared with bash and plain python

```bash
baseName="kai"

# with bash / coreutils
baseName="$(tr '[:lower:]' '[:upper:]' <<< ${baseName:0:1})${baseName:1}"
adminProfileSuffix="AdminRole"
adminProfile="$baseName$adminProfileSuffix"
echo $adminProfile # outputs "KaiAdminRole"

# with python
adminProfile=$(python -c "print('$baseName'.capitalize() + 'AdminRole')")
echo $adminProfile # outputs "KaiAdminRole"

# with py-sh
adminProfile=$(echo $baseName | py-sh 'input.capitalize() + str(AdminRole)')
echo $adminProfile # outputs "KaiAdminRole"
```

## Status

`py-sh` version `1.0` is...

```
1%
```

...implemented.

## Background

I do a lot of lightweight work with `bash` + `coreutils`, and doing that work requires looking up at least one stackoverflow question essentially 100% of the time. This is more or less caused by `bash` + `coreutils` having very esoteric syntax, and not directly catering to the specific needs of engineers working on cli. So you end up having to do things like this

```bash
baseName="kai"
baseName="$(tr '[:lower:]' '[:upper:]' <<< ${baseName:0:1})${baseName:1}"
adminProfileSuffix="AdminRole"
adminProfile="$baseName$adminProfileSuffix"
echo $adminProfile # outputs "KaiAdminRole"
```

That took me two stackoverflow searches to create, and uses a lot of syntax and assumptions that are hard to explain to new engineers.

At the same time, I already know python. I know offhand that in python, the equivalent functionality could be written on the terminal as

```sh
baseName="kai"
adminProfile=$(python -c "print('$baseName'.capitalize() + 'AdminRole')")
echo $adminProfile # outputs "KaiAdminRole"
```

I could create this with knowledge I had on hand! This is a nice boost to my iteration pace, is more readable for my future self, and uses syntax that you're very likely to see when doing other work in python.

It has a few significant flaws, though. In order of increasing importance:

- There's still quote a bit of "shell invocation boilerplate", in the `'`, `"`, `-c`. This is tedious most of the time, but quotes can cause issues with more complex input types.
- The advantage that python has over bash wanes when you start working with more complex input types, like files.
- Its excuting a string (`$baseName`) as arbitrary python code, which is a very easy way to cause a lot of security vulnerabilites.

That sucks. But wait... those are all engineering problems, and maybe all problems that can be solved???

## The Goal

Spoiler: yes we can solve all those problems! We can create something that:

- Assumes its primary operating mode will be in a shell
- Includes builtin handling for files, including files of various data types
- Strictly handles its input types

I'm calling that thing `py-sh`, and I want it to work like this

```sh
baseName="kai"
adminProfile=$(echo $baseName | py-sh 'input.capitalize() + str(AdminRole)')
echo $adminProfile # outputs "KaiAdminRole"
```

## Prior Art

The overarching goal of `py-sh` is very similar to [xonsh](https://xon.sh/index.html), and [ipython shell](https://ipython.readthedocs.io/en/stable/interactive/shell.html). All 3 (`py-sh`, `xonsh`, `ipython shell`) aim to give users to ability to do "shell work" using python. The contrast significantly in their conceptual API though, `py-sh` is meant to be executed inside your existing shell (eg `bash`, `zsh`, etc) - and `xonsh` / `ipython shell` want to replace your shell.

- Finding out about `xonsh` is what originally inspired to author to start exploring this concept 🗺
- Adding support for ipython's concept of [magic commands](https://ipython.readthedocs.io/en/stable/interactive/magics.html) is currently under consideration 📝

The API of `py-sh` is functionally identical to [rb](https://github.com/thisredone/rb). The primary difference is in the implementation details, in that `py-sh` aims to ship itself as a binary that also contains a statically linked binary of its underlying language (eg. python).

- The idea to require api input be piped into `py-sh` was inspired by `rb` ✨
