# Build/lint/test commands

- `flutter test` - Run all tests
- `flutter test test/path/to/test.dart` - Run single test
- `flutter analyze` - Run static analysis
- `dart run build_runner build --delete-conflicting-outputs` - Generate code (freezed/drift/json_serializable)

# Code style

- Use single quotes for strings
- Trailing commas required on multi-line declarations
- Avoid print() - use debugPrint() instead
- Import order: dart imports → package imports → relative imports
- Private members use underscore prefix (\_field)
- Use freezed for immutable models with @freezed annotation
- Use const constructors for widgets where possible
- Error handling: Return Result<T> objects with statusCode pattern
- File structure: models/, repositories/, daos/, pages/, widgets/, constants/, utils/, tables/
- Naming: PascalCase for classes, camelCase for variables/functions, SCREAMING_SNAKE_CASE for constants
- event bloc-driven architecture
