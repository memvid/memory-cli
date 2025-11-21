use clap::{Parser, Subcommand};
use memory_core::{echo, greet, system_info, version};

#[derive(Parser)]
#[command(name = "memorycli")]
#[command(author = "Memvid Team")]
#[command(version)]
#[command(about = "A simple CLI for testing deployment pipelines")]
struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,

    /// Name to greet
    #[arg(short, long)]
    name: Option<String>,
}

#[derive(Subcommand)]
enum Commands {
    /// Display system information
    Info,
    /// Echo a message back
    Echo {
        /// Message to echo
        message: String,
    },
    /// Show version information
    Version,
}

fn main() {
    let cli = Cli::parse();

    // Handle --name flag at root level
    if let Some(name) = cli.name {
        println!("{}", greet(&name));
        return;
    }

    match cli.command {
        Some(Commands::Info) => {
            println!("{}", system_info());
        }
        Some(Commands::Echo { message }) => {
            println!("{}", echo(&message));
        }
        Some(Commands::Version) => {
            println!("memory-cli version {}", version());
        }
        None => {
            println!("{}", greet("World"));
            println!("\nRun 'memorycli --help' for usage information.");
        }
    }
}
