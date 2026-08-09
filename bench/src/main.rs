use std::env;
use std::path::PathBuf;

use adic_bench::{Config, run};

fn main() {
    match parse_args().and_then(|config| run(&config)) {
        Ok(()) => {}
        Err(error) => {
            eprintln!("adic-bench: {error}");
            std::process::exit(2);
        }
    }
}

fn parse_args() -> Result<Config, String> {
    let mut config = Config::default();
    let mut arguments = env::args().skip(1);
    while let Some(argument) = arguments.next() {
        match argument.as_str() {
            "--min-power" => config.min_power = parse_next(&mut arguments, &argument)?,
            "--max-power" => config.max_power = parse_next(&mut arguments, &argument)?,
            "--repetitions" => config.repetitions = parse_next(&mut arguments, &argument)?,
            "--pointer-accesses" => {
                config.pointer_accesses = parse_next(&mut arguments, &argument)?;
            }
            "--stream-min-bytes" => {
                config.stream_min_bytes = parse_next(&mut arguments, &argument)?;
            }
            "--output-dir" => {
                config.output_dir = PathBuf::from(next_value(&mut arguments, &argument)?);
            }
            "--help" | "-h" => {
                print_help();
                std::process::exit(0);
            }
            _ => return Err(format!("unknown argument: {argument}")),
        }
    }
    Ok(config)
}

fn parse_next<T: std::str::FromStr>(
    arguments: &mut impl Iterator<Item = String>,
    flag: &str,
) -> Result<T, String> {
    let value = next_value(arguments, flag)?;
    value
        .parse()
        .map_err(|_| format!("invalid value for {flag}: {value}"))
}

fn next_value(arguments: &mut impl Iterator<Item = String>, flag: &str) -> Result<String, String> {
    arguments
        .next()
        .ok_or_else(|| format!("missing value for {flag}"))
}

fn print_help() {
    println!(
        "adic-bench\n\n\
         Runs pointer-chase, streaming-read, and sequential/random-write sweeps.\n\n\
         Options:\n\
           --min-power N          smallest footprint is 2^N bytes (default: 12)\n\
           --max-power N          largest footprint is 2^N bytes (default: 30)\n\
           --repetitions N        timed runs per case (default: 7)\n\
           --pointer-accesses N   dependent loads per timed run (default: 4194304)\n\
           --stream-min-bytes N   minimum bytes read per timed run (default: 67108864)\n\
           --output-dir PATH      CSV destination (default: bench/results)"
    );
}
