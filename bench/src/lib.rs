use std::fs::{self, File};
use std::hint::black_box;
use std::io::{BufWriter, Write};
use std::mem::size_of;
use std::path::{Path, PathBuf};
use std::time::Instant;

const CACHE_LINE_BYTES: usize = 64;

#[derive(Clone, Debug)]
pub struct Config {
    pub min_power: u32,
    pub max_power: u32,
    pub repetitions: usize,
    pub pointer_accesses: usize,
    pub stream_min_bytes: usize,
    pub output_dir: PathBuf,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            min_power: 12,
            max_power: 30,
            repetitions: 7,
            pointer_accesses: 1 << 22,
            stream_min_bytes: 1 << 26,
            output_dir: PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("results"),
        }
    }
}

impl Config {
    fn validate(&self) -> Result<(), String> {
        if self.min_power > self.max_power {
            return Err("min-power must not exceed max-power".into());
        }
        if self.max_power > 30 {
            return Err("max-power must not exceed 30".into());
        }
        if self.repetitions < 3 {
            return Err("repetitions must be at least 3".into());
        }
        if self.pointer_accesses == 0 {
            return Err("pointer-accesses must be positive".into());
        }
        if self.stream_min_bytes == 0 {
            return Err("stream-min-bytes must be positive".into());
        }
        Ok(())
    }
}

pub fn run(config: &Config) -> Result<(), String> {
    config.validate()?;
    fs::create_dir_all(&config.output_dir).map_err(|error| error.to_string())?;

    let pointer_path = config.output_dir.join("pointer_chase.csv");
    let streaming_path = config.output_dir.join("streaming.csv");
    let write_path = config.output_dir.join("write_asymmetry.csv");
    let mut pointer = csv_writer(&pointer_path)?;
    let mut streaming = csv_writer(&streaming_path)?;
    let mut writes = csv_writer(&write_path)?;

    writeln!(
        pointer,
        "footprint_bytes,elements,repetitions,accesses_per_run,min_ns_per_access,median_ns_per_access,max_ns_per_access"
    )
    .map_err(|error| error.to_string())?;
    writeln!(
        streaming,
        "footprint_bytes,elements,repetitions,passes_per_run,min_ns_per_element,median_ns_per_element,max_ns_per_element,median_gib_per_s"
    )
    .map_err(|error| error.to_string())?;
    writeln!(
        writes,
        "footprint_bytes,cache_lines,repetitions,bytes_per_line,seq_min_ns_per_line,seq_median_ns_per_line,seq_max_ns_per_line,random_min_ns_per_line,random_median_ns_per_line,random_max_ns_per_line,median_random_to_seq_ratio"
    )
    .map_err(|error| error.to_string())?;

    for power in config.min_power..=config.max_power {
        let footprint_bytes = 1usize << power;
        eprintln!("benchmarking 2^{power} bytes ({footprint_bytes} bytes)");
        benchmark_pointer(config, footprint_bytes, &mut pointer)?;
        benchmark_streaming(config, footprint_bytes, &mut streaming)?;
        benchmark_writes(config, footprint_bytes, &mut writes)?;
        pointer.flush().map_err(|error| error.to_string())?;
        streaming.flush().map_err(|error| error.to_string())?;
        writes.flush().map_err(|error| error.to_string())?;
    }

    Ok(())
}

fn csv_writer(path: &Path) -> Result<BufWriter<File>, String> {
    File::create(path)
        .map(BufWriter::new)
        .map_err(|error| format!("failed to create {}: {error}", path.display()))
}

fn benchmark_pointer(
    config: &Config,
    footprint_bytes: usize,
    output: &mut impl Write,
) -> Result<(), String> {
    let elements = footprint_bytes / size_of::<u32>();
    let mut next: Vec<u32> = (0..elements)
        .map(|index| u32::try_from(index).expect("2^30-byte sweep fits u32 indices"))
        .collect();
    make_single_cycle(&mut next, 0x706f_696e_7465_7200 ^ footprint_bytes as u64);

    let warmup_accesses = config.pointer_accesses.min(elements);
    let mut current = chase(&next, 0, warmup_accesses);
    let mut samples = Vec::with_capacity(config.repetitions);
    for _ in 0..config.repetitions {
        let start = Instant::now();
        current = chase(&next, current, config.pointer_accesses);
        samples.push(start.elapsed().as_nanos() as f64 / config.pointer_accesses as f64);
        black_box(current);
    }

    let summary = summarize(samples);
    writeln!(
        output,
        "{footprint_bytes},{elements},{},{},{:.6},{:.6},{:.6}",
        config.repetitions, config.pointer_accesses, summary.min, summary.median, summary.max
    )
    .map_err(|error| error.to_string())
}

fn chase(next: &[u32], mut current: usize, accesses: usize) -> usize {
    for _ in 0..accesses {
        current = next[current] as usize;
    }
    current
}

fn benchmark_streaming(
    config: &Config,
    footprint_bytes: usize,
    output: &mut impl Write,
) -> Result<(), String> {
    let elements = footprint_bytes / size_of::<u64>();
    let data: Vec<u64> = (0..elements)
        .map(|index| (index as u64).wrapping_mul(0x9e37_79b9_7f4a_7c15))
        .collect();
    let passes = config.stream_min_bytes.div_ceil(footprint_bytes).max(1);
    let elements_per_run = elements * passes;

    black_box(stream_sum(&data, 1));
    let mut samples = Vec::with_capacity(config.repetitions);
    for _ in 0..config.repetitions {
        let start = Instant::now();
        black_box(stream_sum(&data, passes));
        samples.push(start.elapsed().as_nanos() as f64 / elements_per_run as f64);
    }

    let summary = summarize(samples);
    let gib_per_second = size_of::<u64>() as f64 / summary.median * 1e9 / (1u64 << 30) as f64;
    writeln!(
        output,
        "{footprint_bytes},{elements},{},{passes},{:.6},{:.6},{:.6},{gib_per_second:.6}",
        config.repetitions, summary.min, summary.median, summary.max
    )
    .map_err(|error| error.to_string())
}

fn stream_sum(data: &[u64], passes: usize) -> u64 {
    let mut sum = 0u64;
    for _ in 0..passes {
        sum = data
            .iter()
            .fold(sum, |accumulator, value| accumulator.wrapping_add(*value));
    }
    sum
}

#[repr(C, align(64))]
#[derive(Clone, Copy)]
struct CacheLine {
    payload: [u32; 16],
}

fn benchmark_writes(
    config: &Config,
    footprint_bytes: usize,
    output: &mut impl Write,
) -> Result<(), String> {
    assert_eq!(size_of::<CacheLine>(), CACHE_LINE_BYTES);
    let cache_lines = footprint_bytes / CACHE_LINE_BYTES;
    let mut lines = vec![CacheLine { payload: [0; 16] }; cache_lines];
    let mut order: Vec<u32> = (0..cache_lines)
        .map(|index| u32::try_from(index).expect("2^30-byte sweep fits u32 line indices"))
        .collect();
    shuffle(&mut order, 0x7772_6974_6573_0000 ^ footprint_bytes as u64);

    sequential_write(&mut lines, 1);
    random_write(&mut lines, &order, 2);
    let mut sequential_samples = Vec::with_capacity(config.repetitions);
    let mut random_samples = Vec::with_capacity(config.repetitions);

    for repetition in 0..config.repetitions {
        let value = u32::try_from(repetition + 3).expect("repetition count fits u32");
        if repetition % 2 == 0 {
            sequential_samples.push(time_sequential_write(&mut lines, value));
            random_samples.push(time_random_write(&mut lines, &order, value));
        } else {
            random_samples.push(time_random_write(&mut lines, &order, value));
            sequential_samples.push(time_sequential_write(&mut lines, value));
        }
    }

    let sequential = summarize_per_item(sequential_samples, cache_lines);
    let random = summarize_per_item(random_samples, cache_lines);
    writeln!(
        output,
        "{footprint_bytes},{cache_lines},{},{CACHE_LINE_BYTES},{:.6},{:.6},{:.6},{:.6},{:.6},{:.6},{:.6}",
        config.repetitions,
        sequential.min,
        sequential.median,
        sequential.max,
        random.min,
        random.median,
        random.max,
        random.median / sequential.median
    )
    .map_err(|error| error.to_string())
}

fn sequential_write(lines: &mut [CacheLine], value: u32) {
    for line in &mut *lines {
        line.payload.fill(value);
    }
    black_box(lines);
}

fn random_write(lines: &mut [CacheLine], order: &[u32], value: u32) {
    for index in order {
        lines[*index as usize].payload.fill(value);
    }
    black_box(&*lines);
}

fn time_sequential_write(lines: &mut [CacheLine], value: u32) -> f64 {
    let start = Instant::now();
    sequential_write(lines, value);
    start.elapsed().as_nanos() as f64
}

fn time_random_write(lines: &mut [CacheLine], order: &[u32], value: u32) -> f64 {
    let start = Instant::now();
    random_write(lines, order, value);
    start.elapsed().as_nanos() as f64
}

fn make_single_cycle(permutation: &mut [u32], seed: u64) {
    let mut random = SplitMix64::new(seed);
    for index in (1..permutation.len()).rev() {
        let other = random.below(index);
        permutation.swap(index, other);
    }
}

fn shuffle(values: &mut [u32], seed: u64) {
    let mut random = SplitMix64::new(seed);
    for index in (1..values.len()).rev() {
        let other = random.below(index + 1);
        values.swap(index, other);
    }
}

struct SplitMix64 {
    state: u64,
}

impl SplitMix64 {
    fn new(seed: u64) -> Self {
        Self { state: seed }
    }

    fn next(&mut self) -> u64 {
        self.state = self.state.wrapping_add(0x9e37_79b9_7f4a_7c15);
        let mut value = self.state;
        value = (value ^ (value >> 30)).wrapping_mul(0xbf58_476d_1ce4_e5b9);
        value = (value ^ (value >> 27)).wrapping_mul(0x94d0_49bb_1331_11eb);
        value ^ (value >> 31)
    }

    fn below(&mut self, upper: usize) -> usize {
        (self.next() % upper as u64) as usize
    }
}

#[derive(Debug)]
struct Summary {
    min: f64,
    median: f64,
    max: f64,
}

fn summarize(mut samples: Vec<f64>) -> Summary {
    samples.sort_by(f64::total_cmp);
    Summary {
        min: samples[0],
        median: samples[samples.len() / 2],
        max: samples[samples.len() - 1],
    }
}

fn summarize_per_item(samples: Vec<f64>, items: usize) -> Summary {
    let divisor = items as f64;
    summarize(samples.into_iter().map(|sample| sample / divisor).collect())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn sattolo_result_is_one_cycle() {
        let mut permutation: Vec<u32> = (0..1024).collect();
        make_single_cycle(&mut permutation, 7);

        let mut seen = vec![false; permutation.len()];
        let mut current = 0usize;
        for _ in 0..permutation.len() {
            assert!(!seen[current]);
            seen[current] = true;
            current = permutation[current] as usize;
        }
        assert_eq!(current, 0);
        assert!(seen.into_iter().all(|entry| entry));
    }

    #[test]
    fn cache_line_layout_is_exact() {
        assert_eq!(size_of::<CacheLine>(), CACHE_LINE_BYTES);
    }
}
