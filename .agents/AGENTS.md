# Workspace Agent Rules

These rules apply to all agent interactions within the SpeakMate workspace.

## C# Coding Standards
- **Primary Constructors:** When creating new classes or modifying existing ones with simple dependency injection, prefer using C# 12 Primary Constructors.
  - Example: `public class MyService(IDependency dependency) { ... }` instead of traditional explicit constructors.
- **Collection Initialization:** Use simplified collection expressions (C# 12 feature) to initialize collections.
  - Example: `List<int> numbers = [1, 2, 3];` instead of `new List<int> { 1, 2, 3 };`
  - Example: `string[] names = ["Alice", "Bob"];` instead of `new string[] { "Alice", "Bob" };`
- **Semantic Logging:** Avoid string interpolation (`$""`) inside `ILogger` methods (SonarQube S2629). Use semantic logging message templates instead.
  - Example: `_logger.LogInformation("Processing user {UserId}", userId);` instead of `_logger.LogInformation($"Processing user {userId}");`
- **Utility Classes:** Add a `protected` constructor to empty partial classes (like `Program` for integration tests) or use the `static` keyword for utility classes to prevent instantiation (SonarQube S1118).
- **No Hardcoded URIs/Paths:** Avoid using hardcoded absolute paths or URIs in service implementations (SonarQube S1075). Configure `HttpClient.BaseAddress` during service registration or inject base URLs via configuration options (`IOptions<T>`).
- **High-Performance Logging Guards (CA1873):** When logging messages that evaluate arguments or variables, wrap `_logger.Log...` calls with `if (_logger.IsEnabled(LogLevel.X))` or use high-performance `[LoggerMessage]` source generator methods to avoid unnecessary parameter evaluations when the log level is disabled.
- **SOLID Principles & Extensible Design:** Adhere strictly to SOLID principles across architecture and configuration design (especially the Open/Closed Principle and Single Responsibility Principle). Avoid modifying existing settings classes by adding provider-specific properties for every new integration. Instead, prefer extensible collections (e.g., `Dictionary<string, string> Endpoints`) or abstraction layers so new providers/strategies can be added without modifying existing contract or settings classes.

