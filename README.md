# Vim Slack

## Introduction

I want to share code without having to copy, switch to Slack, create a new snippet, possibly have to choose my language, paste, etc.

What am I, an animal? It shouldn't be this hard.

I want to share code (or text) with my teammates on slack without leaving vim!

## Demo

## Pre-reqs
------------

You're going to need [curl](https://curl.haxx.se/), most sane systems should have it already.


## Installation
------------

### Pathogen (https://github.com/tpope/vim-pathogen)
```
git clone https://github.com/prashantjois/vim-slack ~/.vim/bundle/vim-slack
```

### Vundle (https://github.com/gmarik/vundle)
```
Plugin 'prashantjois/vim-slack'
```

## Configuration

You need at least to specify your API token:

```
let g:slack_vim_token="xoxp-1234567890-283747610183-320837472577-5687c77204a63ef6496834749a3788ab"
```

Slack can't search users by username, so if you want to post to users in your org by their handles, we have to assume it will be in the format of `username@domain.tld`.

```
let g:slack_email_domain="mydomain.com"
```


## Usage

Currently this plugin only works on line-wise visual selections (that is, no full file sharing or mid-column visual selections will work)

It will upload your text as a snippet to the desired destination (user or channel).

If not specified, the language of the snippet will be inferred from the file type.

That being said, grab a visual selection and ...

### Post a message to one or more channels

To a single channel:

```
:'<,'>Slack -channels my-team
```

To multiple channels (note: don't put spaces in your comma delimited list!)

```
:'<,'>Slack -channels my-team,some-other-team
```

### Post directly to one or more users

To a specific user:

```
:'<,'>Slack -users prashant
```

To multiple users (note: don't put spaces in your comma delimited list!)

```
:'<,'>Slack -users prashant,johnsmith
```

### Give your snippet a title and comment

```
:'<,'>Slack -users prashant -title "Proof that P = NP" -comment "Can I get a second set of eyes on this?"
```

### Specify the language of your selection

```
:'<,'>Slack -users prashant -language python
```
