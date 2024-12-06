// Created by Ryder-C at 2024/12/05 20:33
// leetgo: 1.4.10
// https://leetcode.com/problems/maximum-number-of-integers-to-choose-from-a-range-i/

use anyhow::Result;
use leetgo_rs::*;

struct Solution;

// @lc code=begin

impl Solution {
    pub fn max_count(banned: Vec<i32>, n: i32, max_sum: i32) -> i32 {
        
    }
}

// @lc code=end

fn main() -> Result<()> {
	let banned: Vec<i32> = deserialize(&read_line()?)?;
	let n: i32 = deserialize(&read_line()?)?;
	let max_sum: i32 = deserialize(&read_line()?)?;
	let ans: i32 = Solution::max_count(banned, n, max_sum).into();

	println!("\noutput: {}", serialize(ans)?);
	Ok(())
}
