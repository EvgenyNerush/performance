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
}
