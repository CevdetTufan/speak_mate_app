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
