# Workspace Agent Rules

These rules apply to all agent interactions within the SpeakMate workspace.

## C# Coding Standards
- **Primary Constructors:** When creating new classes or modifying existing ones with simple dependency injection, prefer using C# 12 Primary Constructors.
  - Example: `public class MyService(IDependency dependency) { ... }` instead of traditional explicit constructors.
- **Collection Initialization:** Use simplified collection expressions (C# 12 feature) to initialize collections.
  - Example: `List<int> numbers = [1, 2, 3];` instead of `new List<int> { 1, 2, 3 };`
  - Example: `string[] names = ["Alice", "Bob"];` instead of `new string[] { "Alice", "Bob" };`
