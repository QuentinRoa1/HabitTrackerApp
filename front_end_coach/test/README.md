# Test Breakdowns
Most of the documentation for testing is handled within the tests themselves. This document is intended to be a high-level overview of the tests and their purpose.
## Unit Tests
### api_helper_test.dart
This file contains the tests for the `HttpApiHelper` class. 
This class is a provider responsible for making the API calls to the backend. 
The tests in this file are intended to ensure that the API calls are being made correctly, and that the data is being parsed/handled correctly.
### auth_util_test.dart
This file contains the tests for the `AuthUtil` class.