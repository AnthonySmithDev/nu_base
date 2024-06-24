FROM alpine:edge
RUN apk add git lazygit neovim ripgrep alpine-sdk --update
RUN rm -rf /var/cache/apk/*
RUN git clone https://github.com/LazyVim/starter ~/.config/nvim
WORKDIR /root
CMD ["nvim"]
