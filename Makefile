RUSTFLAGS="-C code-model=kernel -C link-arg=-Tlink.ld relocation-model=static"

default: kernel

.PHONY: clean default kernel

kernel:
	cargo build

clean:
	cargo clean
