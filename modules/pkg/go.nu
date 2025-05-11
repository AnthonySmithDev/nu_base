
export def names [] {
  packages | get name
}

def installer [pkgs: table] {
  for $pkg in $pkgs {
    go install $pkg.url
  }
}

export def install [...names: string@names] {
  installer (packages | where {|e| $e.name in $names})
}

export def dev [] {
  installer (packages | where category == dev)
}

export def db [] {
  installer (packages | where category == db)
}

export def core [] {
  installer (packages | where category == core)
}

export def extra [] {
  installer (packages | where category == extra)
}

export def touchpad [] {
  go install -tags uinput github.com/unrud/remote-touchpad@latest
}

export def packages [] {
  [
    [ category name url];
		[ dev gopls golang.org/x/tools/gopls@latest ]
		[ dev dlv github.com/go-delve/delve/cmd/dlv@latest ]
		[ dev staticcheck honnef.co/go/tools/cmd/staticcheck@latest ]
		[ dev golangci-lint github.com/golangci/golangci-lint/cmd/golangci-lint@latest ]
		[ dev golangci-lint-langserver github.com/nametake/golangci-lint-langserver@latest ]

		[ dev air github.com/air-verse/air@latest ]
		[ dev swag github.com/swaggo/swag/cmd/swag@latest ]
		[ dev pp github.com/maruel/panicparse/v2/cmd/pp@latest ]

		[ db ent entgo.io/ent/cmd/ent@latest ]
		[ db atlas ariga.io/atlas/cmd/atlas@latest ]
		[ db entimport ariga.io/entimport/cmd/entimport@latest ]

		[ core task github.com/go-task/task/v3/cmd/task@latest ]
		[ core lazygit github.com/jesseduffield/lazygit@latest ]
		[ core lazydocker github.com/jesseduffield/lazydocker@latest ]

		[ core usql github.com/xo/usql@latest ]
		[ core fzf github.com/junegunn/fzf@latest ]
		[ core fm github.com/mistakenelf/fm@latest ]
		[ core bombardier github.com/codesenberg/bombardier@latest ]

		[ core guru github.com/shafreeck/guru@latest ]

		[ core gum github.com/charmbracelet/gum@latest ]
		[ core mods github.com/charmbracelet/mods@latest ]
		[ core vhs github.com/charmbracelet/vhs@latest ]
		[ core glow github.com/charmbracelet/glow@latest ]
		[ core nap github.com/maaslalani/nap@main ]
		[ core tty-share github.com/elisescu/tty-share@latest ]
		[ core termshot github.com/homeport/termshot/cmd/termshot@latest ]

		[ core duf github.com/muesli/duf@latest ]
		[ core fx github.com/antonmedv/fx@latest ]
		[ core qrcp github.com/claudiodangelis/qrcp@latest ]
		[ core gdu github.com/dundee/gdu/v5/cmd/gdu@latest ]
		[ core chatgpt github.com/j178/chatgpt/cmd/chatgpt@latest ]
		[ core tgpt github.com/aandrew-me/tgpt/v2@latest ]
		[ core jet github.com/go-jet/jet/v2/cmd/jet@latest ]

		[ extra cointop github.com/cointop-sh/cointop@latest ]
		[ extra cryptgo github.com/Gituser143/cryptgo@latest ]
		[ extra wails github.com/wailsapp/wails/v2/cmd/wails@latest ]

		[ extra viddy github.com/sachaos/viddy@latest ]
		[ extra eget github.com/zyedidia/eget@latest ]
		[ extra bit github.com/chriswalz/bit@latest ]

		[ extra slides github.com/maaslalani/slides@latest ]
		[ extra confetty github.com/maaslalani/confetty@latest ]
		[ extra gat github.com/koki-develop/gat@latest ]
		[ extra gambit github.com/maaslalani/gambit@latest ]
		[ extra bettercap github.com/bettercap/bettercap@latest  ]
	]
}
