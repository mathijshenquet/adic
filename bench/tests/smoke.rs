use std::fs;
use std::time::{SystemTime, UNIX_EPOCH};

use adic_bench::{Config, run};

#[test]
fn tiny_sweep_writes_all_result_tables() {
    let nonce = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("system clock is after Unix epoch")
        .as_nanos();
    let output_dir =
        std::env::temp_dir().join(format!("adic-bench-smoke-{}-{nonce}", std::process::id()));
    let config = Config {
        min_power: 12,
        max_power: 14,
        repetitions: 3,
        pointer_accesses: 4096,
        stream_min_bytes: 16 * 1024,
        output_dir: output_dir.clone(),
    };

    run(&config).expect("tiny benchmark sweep runs");
    for name in ["pointer_chase.csv", "streaming.csv", "write_asymmetry.csv"] {
        let contents = fs::read_to_string(output_dir.join(name)).expect("result CSV exists");
        assert_eq!(contents.lines().count(), 4, "header plus three data rows");
    }

    fs::remove_dir_all(output_dir).expect("smoke output is removable");
}
