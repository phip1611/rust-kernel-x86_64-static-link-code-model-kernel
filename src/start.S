# Rust uses a GAS-like (GNU Assembly) syntax for global and inline assembler. This is documented
# here: https://doc.rust-lang.org/nightly/reference/inline-assembly.html


# start symbol must be globally available (linker must find it, don't discard it)
.GLOBAL entry_asm

# entry point into Rust code
.EXTERN entry_rust

.section .text
.code64

    # Entry referenced by the ELF file
    entry_asm:
        nop
        nop
        nop
        movabs r15, 0xdeadbeef
        jmp entry_rust
        ud2

# section must be resetted according to rust doc
# .section .text
