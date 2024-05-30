FROM alpine:edge
RUN apk add bash git lua nodejs npm lazygit bottom python3 go neovim ripgrep alpine-sdk --update
RUN rm -rf /var/cache/apk/*
RUN git clone https://github.com/LunarVim/LunarVim.git ~/.config/nvim
WORKDIR /root
CMD ["nvim"]
