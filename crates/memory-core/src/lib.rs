/// Greets a user by name
pub fn greet(name: &str) -> String {
    format!("Hello, {}! Welcome to Memory CLI.", name)
}

/// Returns the version of memory-core
pub fn version() -> &'static str {
    env!("CARGO_PKG_VERSION")
}

/// Simple echo function
pub fn echo(message: &str) -> String {
    message.to_string()
}

/// Returns system info (for testing)
pub fn system_info() -> String {
    format!(
        "OS: {}\nArch: {}\nVersion: {}",
        std::env::consts::OS,
        std::env::consts::ARCH,
        version()
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_greet() {
        assert_eq!(
            greet("Sharafdiin"),
            "Hello, Sharafdiin! Welcome to Memory CLI."
        );
    }

    #[test]
    fn test_echo() {
        assert_eq!(echo("test"), "test");
    }
}
