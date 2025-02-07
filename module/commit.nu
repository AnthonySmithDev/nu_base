
export-env {
  $env.COMMIT_IDENTITY = 'You are to act as the author of a commit message in git.'
  $env.COMMIT_EMOJI = true
  $env.COMMIT_DESCRIPTION = true
  $env.COMMIT_LANGUAGE = "spanish"
}

def emoji [] {
  if $env.COMMIT_EMOJI {
    "Use GitMoji convention to preface the commit."
  } else {
    "Do not preface the commit with anything."
  }
}

def description [] {
  if $env.COMMIT_DESCRIPTION {
    "Add a short description of WHY the changes are done after the commit message. Don't start it with 'This commit', just describe the changes."
  } else {
    "Don't add any descriptions to the commit, only commit message."
  }
}

export def prompt [] {
  $"($env.COMMIT_IDENTITY) Your mission is to create clean and comprehensive commit messages as per the conventional commit convention and explain WHAT were the changes and mainly WHY the changes were done. I'll send you an output of 'git diff --staged' command, and you are to convert it into a commit message. (emoji) (description) Use the present tense. Lines must not be longer than 74 characters. Use ($env.COMMIT_LANGUAGE) for the commit message."
}

export def main [] {
  let prompt = prompt
  for $file in (git diff --staged --name-only | lines) {
    git diff --staged $file | mods $prompt --quiet --no-cache
  }
}

export def merge_diffs [] {
  git diff | split row  "diff --git" | skip 1 | str join
}

export def gpt [] {
  $"Use GitMoji convention to preface the commit.
  suggest 10 commit messages based on the following diff:
  (merge_diffs)

  commit messages should:
   - follow conventional commits
   - message format should be: <type>[scope] [emojit]: <description>

  examples:
   - fix\(authentication\): add password regex pattern
   - feat\(storage\): add new test cases"
}


export def req [] {
  let system = " You are to act as the author of a commit message in git. Your mission is to create clean and comprehensive commit messages as per the conventional commit convention and explain WHAT were the changes and mainly WHY the changes were done. I'll send you an output of 'git diff --staged' command, and you are to convert it into a commit message.
  Use GitMoji convention to preface the commit. Here are some help to choose the right emoji (emoji, description): 🐛, Fix a bug; ✨, Introduce new features; 📝, Add or update documentation; 🚀, Deploy stuff; ✅, Add, update, or pass tests; ♻, Refactor code; ⬆, Upgrade dependencies; 🔧, Add or update configuration files; 🌐, Internationalization and localization; 💡, Add or update comments in source code; Don't add any descriptions to the commit, only commit message."

  let user = "
Use the present tense. Lines must not be longer than 74 characters. Use spanish for the commit message.
diff --git a/src/server.ts b/src/server.ts
  index ad4db42..f3b18a9 100644
  --- a/src/server.ts
  +++ b/src/server.ts
  @@ -10,7 +10,7 @@
  import {
    initWinstonLogger();

    const app = express();
    -const port = 7799;
    +const PORT = 7799;

    app.use(express.json());

    @@ -34,6 +34,6 @@
    app.use((_, res, next) => {
      // ROUTES
      app.use(PROTECTED_ROUTER_URL, protectedRouter);

      -app.listen(port, () => {
          -  console.log(`Server listening on port ${port}`);
      +app.listen(process.env.PORT || PORT, () => {
          +  console.log(`Server listening on port ${PORT}`);
      });"

  let assistant = "
🐛 (server.ts): cambiar la variable port de minúsculas a mayúsculas PORT
✨ (server.ts): añadir soporte para la variable de entorno process.env.PORT
  "

  let body = {
    "model": "llama3",
    "messages": [
      {
          "role": "system",
          "content": $system
      },
      {
          "role": "user",
          "content": $user
      },
      {
          "role": "assistant",
          "content": $assistant
      },
      {
          "role": "user",
          "content": (merge_diffs)
      }
    ]
  }
  http post --content-type application/json http://r2v2:11434/v1/chat/completions $body
}
