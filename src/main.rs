// Disable rust standard library: will not work for several reasons:
//   1) the minimal Rust runtime is not there (similar to crt0 for C programs)
//   2) we write Kernel code, but standard lib makes syscalls and is meant for userland programs
#![no_std]
#![no_main]

#![feature(lang_items)]

use core::panic::PanicInfo;
core::arch::global_asm!(include_str!("start.S"));

/// This symbol is referenced in "start.S". It doesn't need the "pub"-keyword,
/// because visibility is a Rust feature and not important for the object file.
#[no_mangle]
fn entry_rust() -> ! {
    loop {}
}

// see https://docs.rust-embedded.org/embedonomicon/smallest-no-std.html
#[lang = "eh_personality"]
extern "C" fn eh_personality() {}

#[panic_handler]
fn panic_pandler(_info: &PanicInfo) -> ! {
    loop {

    }
}