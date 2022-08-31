# Static Binary with Kernel Code Model from Rust Build for x86_64

## What does this repository show?
This demo shows how you can compile a static kernel binary with the built-in Rust compiler target 
`x86_64-unknown-none`. It uses the "kernel" code model from the System V ABI and links the 
kernel statically to `0xffffffff88000000`. Thus, the loader of the ELF, i.e., the bootloader,
doesn't have to resolve relocations during load time and can load it into memory.

## Why does one to do it this way?
Kernels, i.e., the thing that the bootloader loads, need to be relocatable. In early boot phases
you do not have paging at all (legacy/BIOS boot) or identity mapping (UEFI boot). Bootloaders such
as GRUB do not support fully relocatable, thus dynamic, ELF files. So how to solve this problem?

GRUB (and other bootloader) can relocate a static binary relatively easy by applying an offset. 
This is no problem as long as the early manually written assembly code executes. This usually only 
uses relative addressing. However, jumping into high-level code then results in undefined behaviour
as the code doesn't run at its expected (virtual) address. Some instructions from high level 
languages use absolute addressing. You can not work around this.

But with the approach taken by my example, you can solve this easily. The startup routine 
written in assembly is position independent and can be loaded for example by GRUB via multiboot2.
We can bring the current CPU into the 64-bit long mode state, set up page tables in assembly for 
the given address, and then jump into the high level code. All further initialization will be done
by the high level Rust code. The only downside is that we have to do some minor initialization in 
assembly rather than a high-level language.

I was inspired by [Hedron](https://github.com/cyberus-technology/hedron) that solves the problem 
that way.