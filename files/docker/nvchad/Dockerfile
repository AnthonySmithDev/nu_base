FROM alpine:edge
RUN apk add git nodejs npm neovim ripgrep build-base wget --update
RUN git clone https://github.com/NvChad/NvChad ~/.config/nvim
WORKDIR /root
CMD ["nvim"]
