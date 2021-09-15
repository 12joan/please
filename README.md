# Please

**⚠️ Requires an access token for OpenAI Codex, which is currently in private beta**

Convert natural language to bash commands using OpenAI Codex

![Demo video](https://user-images.githubusercontent.com/4272090/133416481-febce287-1c3b-4a10-ab3e-b7228d403d7a.gif)

## Installation

    $ gem install openai-please

Ensure your [OpenAI API key](https://help.openai.com/en/articles/5480100-how-do-i-gain-access-to-openai-codex) is stored in an environment variable.

```
OPENAI_ACCESS_TOKEN=[YOUR ACCESS TOKEN HERE]
```

## Usage

```shell
user@host:~$ please find all files larger than 1 mb
$ find . -type f -size +1M
Run the command? (enter "h" for help) [y,n,e,h]
```

You can [e]dit the command before running it by pressing the 'e' key. This uses the editor specified in the $EDITOR variable, defaulting to vi.

## Privacy

In addition to the instruction text, the result of each of the following commands is sent to OpenAI Codex to improve the relevance of completions.

- `pwd`
- `uname -a`
- `ls -a`

See [OpenAI's privacy policy](https://beta.openai.com/policies/privacy-policy) for more information.
