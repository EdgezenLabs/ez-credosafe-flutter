# Flutter Best Practices - CredoSafe

## 📚 Table of Contents
1. [Project Structure](#project-structure)
2. [Naming Conventions](#naming-conventions)
3. [Code Organization](#code-organization)
4. [State Management](#state-management)
5. [Error Handling](#error-handling)
6. [Performance](#performance)
7. [Security](#security)
8. [Testing](#testing)
9. [Documentation](#documentation)
10. [Git Workflow](#git-workflow)

---

## 🗂️ Project Structure

### Follow Feature-First Organization
```
lib/
├── core/          # Framework-independent logic
├── config/        # App configuration
├── models/        # Data models
├── providers/     # State management
├── screens/       # UI screens (organized by feature)
├── services/      # External services
├── widgets/       # Reusable widgets
└── main.dart      # App entry point
```

### Keep Files Small
- **Max 300-400 lines per file**
- Split large widgets into smaller components
- Extract complex logic into separate files

---

## 📝 Naming Conventions

### Files
```
✅ snake_case for files
loan_status_screen.dart
user_profile_provider.dart
gradient_button.dart

❌ Avoid
LoanStatusScreen.dart
userProfileProvider.dart
GradientButton.dart
```

### Classes
```
✅ PascalCase for classes
class LoanStatusScreen extends StatelessWidget {}
class UserProfileProvider extends ChangeNotifier {}

❌ Avoid
class loanStatusScreen {}
class user_profile_provider {}
```

### Variables & Methods
```
✅ camelCase for variables and methods
String userName = 'John';
void getUserData() {}

❌ Avoid
String UserName = 'John';
void GetUserData() {}
```

### Constants
```
✅ camelCase with const/final
const String apiUrl = '...';
final int maxAttempts = 3;

✅ UPPER_CASE for environment configs
const String API_BASE_URL = '...';
```

### Private Members
```
✅ Prefix with underscore
String _privateVariable;
void _privateMethod() {}
```

---

## 🏗️ Code Organization

### Import Order
```dart
// 1. Dart imports
import 'dart:async';
import 'dart:io';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Package imports (alphabetically)
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

// 4. Relative imports (alphabetically)
import '../core/core.dart';
import '../config/app_colors.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
```

### Class Member Order
```dart
class ExampleWidget extends StatelessWidget {
  // 1. Static constants
  static const String defaultTitle = 'Example';
  
  // 2. Final fields
  final String title;
  final VoidCallback? onTap;
  
  // 3. Mutable fields
  String? description;
  
  // 4. Constructor
  const ExampleWidget({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);
  
  // 5. Lifecycle methods
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
  // 6. Private build methods
  Widget _buildHeader() {
    return Container();
  }
  
  Widget _buildBody() {
    return Container();
  }
  
  // 7. Private helper methods
  void _handleTap() {
    // Logic here
  }
  
  // 8. Public methods
  void showMessage() {
    // Logic here
  }
}
```

### Extract Complex Widgets
```dart
// ❌ Bad: Everything in one widget
class LoanStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 100 lines of header code
          Container(...),
          
          // 150 lines of body code
          Column(...),
          
          // 80 lines of footer code
          Row(...),
        ],
      ),
    );
  }
}

// ✅ Good: Extracted widgets
class LoanStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _LoanStatusHeader(),
          _LoanStatusBody(),
          _LoanStatusFooter(),
        ],
      ),
    );
  }
}
```

---

## 🔄 State Management

### Use Provider Pattern
```dart
// 1. Create Provider
class LoanProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Loan> _loans = [];
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Loan> get loans => _loans;
  
  Future<void> fetchLoans() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _loans = await apiService.fetchLoans();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}

// 2. Provide at app level
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => LoanProvider()),
  ],
  child: MyApp(),
);

// 3. Consume in widgets
// Use Consumer for reactive updates
Consumer<LoanProvider>(
  builder: (context, provider, child) {
    if (provider.isLoading) return LoadingWidget();
    if (provider.error != null) return ErrorWidget(provider.error!);
    return LoanList(provider.loans);
  },
);

// Use context.read for one-time actions
ElevatedButton(
  onPressed: () {
    context.read<LoanProvider>().fetchLoans();
  },
  child: Text('Refresh'),
);

// Use context.watch for simple reactive updates
final isLoading = context.watch<LoanProvider>().isLoading;
```

### Avoid Unnecessary Rebuilds
```dart
// ❌ Bad: Entire widget rebuilds
Consumer<LoanProvider>(
  builder: (context, provider, child) {
    return Column(
      children: [
        StaticHeader(),       // Rebuilds unnecessarily
        LoanList(provider.loans),
        StaticFooter(),       // Rebuilds unnecessarily
      ],
    );
  },
);

// ✅ Good: Only necessary parts rebuild
Column(
  children: [
    StaticHeader(),
    Consumer<LoanProvider>(
      builder: (context, provider, child) {
        return LoanList(provider.loans);
      },
    ),
    StaticFooter(),
  ],
);
```

---

## 🐛 Error Handling

### Use Try-Catch Blocks
```dart
Future<void> uploadDocument() async {
  try {
    await apiService.uploadDocument(file);
    SnackbarHelper.showSuccess(context, 'Upload successful');
  } on NetworkException catch (e) {
    SnackbarHelper.showError(context, 'Network error: ${e.message}');
  } on ServerException catch (e) {
    SnackbarHelper.showError(context, 'Server error: ${e.message}');
  } catch (e) {
    SnackbarHelper.showError(context, 'Unexpected error: $e');
  }
}
```

### Validate User Input
```dart
// Use validators
TextFormField(
  controller: emailController,
  validator: Validators.validateEmail,
  decoration: InputDecoration(
    labelText: 'Email',
    errorMaxLines: 2,
  ),
);

// Check before submitting
if (_formKey.currentState!.validate()) {
  // Submit form
} else {
  SnackbarHelper.showWarning(context, 'Please fix errors');
}
```

### Handle Null Safety
```dart
// ✅ Good: Safe navigation
final userName = user?.name ?? 'Guest';
final email = user?.email?.toLowerCase();

// ✅ Good: Assert non-null when certain
final definitelyNotNull = value!;

// ❌ Bad: Forcing non-null without checking
final unsafe = user!.name;
```

---

## ⚡ Performance

### Use const Constructors
```dart
// ✅ Good: Compile-time constant
const Text('Hello');
const SizedBox(height: 16);
const Icon(Icons.check);

// ❌ Bad: Runtime object creation
Text('Hello');
SizedBox(height: 16);
Icon(Icons.check);
```

### Cache Expensive Computations
```dart
// ❌ Bad: Recomputed on every rebuild
@override
Widget build(BuildContext context) {
  final sortedList = loans.sort((a, b) => ...);  // Expensive!
  return ListView.builder(...);
}

// ✅ Good: Cached
class _LoanScreenState extends State<LoanScreen> {
  late final List<Loan> sortedLoans;
  
  @override
  void initState() {
    super.initState();
    sortedLoans = loans.sort((a, b) => ...);  // Computed once
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(...);
  }
}
```

### Use ListView.builder for Long Lists
```dart
// ❌ Bad: Creates all widgets at once
ListView(
  children: loans.map((loan) => LoanCard(loan)).toList(),
);

// ✅ Good: Lazy loading
ListView.builder(
  itemCount: loans.length,
  itemBuilder: (context, index) {
    return LoanCard(loans[index]);
  },
);
```

### Optimize Images
```dart
// Use cached network images
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
);

// Specify image dimensions
Image.asset(
  'assets/logo.png',
  width: 100,
  height: 100,
);
```

---

## 🔒 Security

### Never Hardcode Sensitive Data
```dart
// ❌ Bad
const String apiKey = 'sk-1234567890abcdef';

// ✅ Good: Use environment variables or secure storage
final apiKey = await secureStorage.read(key: 'api_key');
```

### Validate All User Input
```dart
// Server-side validation is mandatory
// Client-side validation improves UX
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) return 'Required';
    if (value.length < 8) return 'Too short';
    return null;
  },
);
```

### Use HTTPS
```dart
// ✅ Always use HTTPS
const String apiUrl = 'https://api.credosafe.com';

// ❌ Never use HTTP for sensitive data
// const String apiUrl = 'http://api.credosafe.com';
```

### Secure Local Storage
```dart
// Use flutter_secure_storage for sensitive data
final storage = FlutterSecureStorage();
await storage.write(key: 'token', value: token);
final token = await storage.read(key: 'token');
```

---

## 🧪 Testing

### Write Unit Tests
```dart
// test/validators_test.dart
void main() {
  group('Validators', () {
    test('validates correct email', () {
      expect(Validators.validateEmail('test@email.com'), null);
    });
    
    test('rejects invalid email', () {
      expect(Validators.validateEmail('invalid'), isNotNull);
    });
  });
}
```

### Write Widget Tests
```dart
// test/widget_test.dart
void main() {
  testWidgets('Login button is disabled when empty', (tester) async {
    await tester.pumpWidget(MyApp());
    
    final button = find.text('Login');
    expect(button, findsOneWidget);
    
    await tester.tap(button);
    await tester.pump();
    
    expect(find.text('Email is required'), findsOneWidget);
  });
}
```

---

## 📖 Documentation

### Add Doc Comments
```dart
/// Validates an email address.
///
/// Returns an error message if the email is invalid,
/// or `null` if the email is valid.
///
/// Example:
/// ```dart
/// String? error = Validators.validateEmail('test@email.com');
/// if (error != null) {
///   print('Error: $error');
/// }
/// ```
String? validateEmail(String? value) {
  // Implementation
}
```

### Use Meaningful Names
```dart
// ❌ Bad: Unclear names
var d = 10;
void p() {}

// ✅ Good: Self-documenting
var daysUntilExpiry = 10;
void processPayment() {}
```

### Comment Complex Logic
```dart
// Calculate compound interest with monthly compounding
// Formula: A = P(1 + r/n)^(nt)
// where P = principal, r = rate, n = compounds per year, t = years
double calculateInterest(double principal, double rate, int years) {
  const int compoundsPerYear = 12;
  return principal * pow(1 + rate / compoundsPerYear, compoundsPerYear * years);
}
```

---

## 🔀 Git Workflow

### Commit Messages
```
✅ Good:
feat: Add loan application form
fix: Resolve document upload error
docs: Update README with setup instructions
refactor: Extract validation logic to utils
style: Format code with dartfmt
test: Add unit tests for validators

❌ Bad:
Update
Fix bug
Changes
WIP
```

### Branch Naming
```
✅ Good:
feature/loan-application-form
bugfix/document-upload-error
hotfix/login-crash
refactor/validation-logic

❌ Bad:
new-feature
fixes
updates
test
```

### Pull Requests
- Clear title and description
- Reference related issues
- Add screenshots for UI changes
- Request review from team members
- Ensure tests pass before merging

---

## 🎯 Quick Checklist

Before committing code, ensure:

- [ ] Code follows naming conventions
- [ ] Files are organized properly
- [ ] No hardcoded sensitive data
- [ ] Input validation is present
- [ ] Error handling is implemented
- [ ] const constructors are used where possible
- [ ] No unused imports or variables
- [ ] Code is formatted (`flutter format .`)
- [ ] No analysis issues (`flutter analyze`)
- [ ] Tests pass (`flutter test`)
- [ ] Documentation is updated
- [ ] Commit message is clear

---

## 📚 Resources

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Provider Documentation](https://pub.dev/packages/provider)

---

**Remember**: Good code is code that is easy to read, understand, and maintain!
