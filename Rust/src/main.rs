extern crate rand;
extern crate time;

use std::f64::consts;
use rand::Rng;

fn main() {
    let n: usize = 2_000_000;
    // 1st method
    let t0 = time::precise_time_ns();
    let mut sum1 = 0.0; // f64 by default
    for _ in 0..(2 * n) { // int_0^1 asin(sqrt(x)) dx = 1 / 2
        let r1 = rand::thread_rng().gen_range(0.0, 1.0);
        let r2 = rand::thread_rng().gen_range(0.0, 1.0);
        sum1 += if r2 < f64::asin(f64::sqrt(r1)) / (consts::PI / 2.0) {
            r1
        } else {
            0.0
        }
    }
    let t1 = time::precise_time_ns();
    println!("1st method gives = {}", sum1 / n as f64);
    println!("...that takes {} s", (t1 - t0) as f64 / 1.0e9);
    // 2nd method
    let mut v = vec![0.0; n];
    let mut i: usize = 0;
    while i < n {
        let r1 = rand::thread_rng().gen_range(0.0, 1.0);
        let r2 = rand::thread_rng().gen_range(0.0, 1.0);
        if r2 < f64::asin(f64::sqrt(r1)) / (consts::PI / 2.0) {
            v[i] = r1;
            i += 1;
        }
    }
    let mut sum2 = 0.0;
    for x in v {
        sum2 += x;
    }
    let t2 = time::precise_time_ns();
    println!("2nd method gives = {}", sum2 / n as f64);
    println!("...that takes {} s", (t2 - t1) as f64 / 1.0e9);
    // 3rd method uses lcg rng from C99 standard suggestion, see
    // https://en.wikipedia.org/wiki/Linear_congruential_generator
    const M: u32 = 2_147_483_648; // 2^31
    const A: u32 = 1_103_515_245;
    const C: u32 = 12_345;
    let mut x: u32 = 5; // rng state
    let mut sum3 = 0.0;
    for _ in 0..(2 * n) { // int_0^1 asin(sqrt(x)) dx = 1 / 2
        x = (A * x + C) & (M - 1); // fast mod (2^N) operation
        let r1 = (x as f64) / (M as f64);
        x = (A * x + C) & (M - 1); // fast mod (2^N) operation
        let r2 = (x as f64) / (M as f64);
        sum3 += if r2 < f64::asin(f64::sqrt(r1)) / (consts::PI / 2.0) {
            r1
        } else {
            0.0
        }
    }
    let t3 = time::precise_time_ns();
    println!("3rd method gives = {}", sum3 / (n as f64));
    println!("...that takes {} s", (t3 - t2) as f64 / 1.0e9);
}
