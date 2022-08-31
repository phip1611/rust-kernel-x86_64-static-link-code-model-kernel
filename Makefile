# We need to apply certain Rust flags to the WHOLE build to enable the kernel code-model of the
# System V ABI. Otherwise we get stuck with ugly build problems during link time such as
# "relocation R_X86_64_32 out of range". See https://github.com/rust-lang/rust/issues/101209
#
# - code-model=kernel       : We want to link the kernel to the upper half of the address space
# - link-arg=-Tlink.l       : We want to use a custom linker script.
# - relocation-model=static : We want to produce an executable ELF and not a dynamic ELF.
#                             Bootloaders such as ELF can load executable ELF files easy into
#                             memory but do not support dynamic ELF files out of the box, as this
#                             requires additional policies in the bootloader.
export RUSTFLAGS=-C code-model=kernel -C link-arg=-Tlink.ld -C relocation-model=static

default: kernel

.PHONY: clean default kernel

kernel:
	cargo build

clean:
	cargo clean
