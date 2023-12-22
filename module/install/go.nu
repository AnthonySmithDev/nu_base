export def dev [] {
	go install 'golang.org/x/tools/gopls@latest'
	go install 'github.com/go-delve/delve/cmd/dlv@latest'
	go install 'github.com/cosmtrek/air@latest'
	go install 'github.com/swaggo/swag/cmd/swag@latest'
	go install 'github.com/go-task/task/v3/cmd/task@latest'
	go install 'github.com/go-jet/jet/v2/cmd/jet@latest'
	go install 'entgo.io/ent/cmd/ent@latest'
}

export def core [] {
	go install 'github.com/jesseduffield/lazygit@latest'
	go install 'github.com/jesseduffield/lazydocker@latest'

	go install 'github.com/xo/usql@latest'
	go install 'github.com/junegunn/fzf@latest'
	go install 'github.com/mistakenelf/fm@latest'
	go install 'github.com/codesenberg/bombardier@latest'

	go install 'github.com/shafreeck/guru@latest'

	go install 'github.com/charmbracelet/gum@latest'
	go install 'github.com/charmbracelet/mods@latest'
	go install 'github.com/charmbracelet/vhs@latest'
	go install 'github.com/charmbracelet/glow@latest'
	go install 'github.com/maaslalani/nap@main'
	go install 'github.com/elisescu/tty-share@latest'
	go install 'github.com/homeport/termshot/cmd/termshot@latest'

	go install 'github.com/muesli/duf@latest'
	go install 'github.com/antonmedv/fx@latest'
	go install 'github.com/claudiodangelis/qrcp@latest'
	go install 'github.com/dundee/gdu/v5/cmd/gdu@latest'
	go install 'github.com/j178/chatgpt/cmd/chatgpt@latest'
	go install github.com/aandrew-me/tgpt/v2@latest
}

export def extra [] {
	go install 'github.com/cointop-sh/cointop@latest'
	go install 'github.com/Gituser143/cryptgo@latest'
	go install github.com/wailsapp/wails/v2/cmd/wails@latest

	go install 'github.com/sachaos/viddy@latest'
	go install 'github.com/zyedidia/eget@latest'
	go install 'github.com/chriswalz/bit@latest'

	go install 'github.com/maaslalani/slides@latest'
}
