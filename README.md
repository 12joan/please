# Please

**⚠️ Requires an access token for OpenAI Codex, which is currently in private beta**

Convert natural language to bash commands using OpenAI Codex

![Demo video](https://user-images.githubusercontent.com/4272090/133416481-febce287-1c3b-4a10-ab3e-b7228d403d7a.gif)

## Installation

    $ gem install openai-please

Provide your [OpenAI API key](https://beta.openai.com/account/api-keys) in an environment variable, or using the [configuration file](#configuration).

```
OPENAI_ACCESS_TOKEN=[YOUR ACCESS TOKEN HERE]
```

## Usage

Type `please`, followed by an instruction written in natural language.

```shell
user@host:~$ please find all files larger than 1 mb
$ find . -type f -size +1M
Run the command? (enter "h" for help) [y,n,e,h]
```

You can [e]dit the command before running it by pressing the 'e' key. This uses the command specified in the `$EDITOR` variable, or `vi` if no editor is set.

See `please --help` for more information.

## Configuration

You can modify the default configuration in `~/.config/please/config.yml`.

```yaml
send_pwd: false             # default: true
send_ls: false              # default: true
send_uname: true            # default: true

access_token: ...           # default: $OPENAI_ACCESS_TOKEN

examples:                   # default: []
  - instruction: Run my super secret command
    command: /super/secret/command
    
  - instruction: Show git status
    command: git status
    execute: true           # default: false
    
skip_default_examples: true # default: false
```

### `examples`

Any examples listed here will be added to the prompt in the following form.

```
# INSTRUCTION
$ COMMAND
[RESULT, if execute is set to true]
```

If `execute` is set to true, the command will be executed prior to sending the request and the result will be included in the prompt. This is useful for providing dynamic context which the AI can use to inform completions.

### `skip_default_examples`

Do not include the default set of examples in the prompt. You can see the full prompt by running `please --show-prompt`. 

*Note:* This option does not automatically imply `send_*: false`. To remove all examples from the prompt other than those explicitly specified, use this option in combination with the `send_*: false` options.

## Privacy

By default, the result of each of the following commands is sent to OpenAI Codex to improve the relevance of completions.

- `pwd`
- `uname -a`
- `ls -a`

This behaviour can be disabled using the configuration options described above. You can review the prompt before sending it to OpenAI by running `please --show-prompt`. 

See [OpenAI's privacy policy](https://beta.openai.com/policies/privacy-policy) for more information.

## Development

With Docker:

1. Copy `.env.example` to `.env` and add your OpenAI access token
2. (Optional) Add a custom config in `./config/config.yml`
3. Run `docker-compose run --rm please rake` to run the tests and RuboCop
4. Run `docker-compose run --rm please please <instruction>` to run the CLI

Without Docker:

1. Create an environment variable `OPENAI_ACCESS_TOKEN` containing your OpenAI access token
2. (Optional) Add a custom config in `~/.config/please/config.yml`
3. Run `bundle install` to install the dependencies
4. Run `bundle exec rake` to run the tests and RuboCop
5. Run `bundle exec exe/please <instruction>` to run the CLI
