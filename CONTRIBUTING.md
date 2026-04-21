# Contributing to Interslavic Keyboards

Thank you for your interest in contributing to the Medžuslovjansky Keyboards project! This document provides general guidelines and instructions for contributing.

## Project Overview

This repository is organized by platform, with each platform having its own directory containing platform-specific implementation, build scripts, and documentation. Before contributing, please familiarize yourself with the platform-specific guidelines for the area you wish to work on.

- [Linux Contribution Guide](linux/CONTRIBUTING.md)

## General Development Guidelines

### Pull Request Process

1. **Branch Naming:**
   - Features: `feature/description`
   - Fixes: `fix/description`
   - Documentation: `docs/description`

2. **Before Submitting:**
   - Run all platform-specific tests
   - Update documentation if needed
   - Add test cases for new features

3. **Pull Request Description:**
   - Clearly describe the changes
   - Reference any related issues
   - List any breaking changes
   - Include testing steps

4. **Review Process:**
   - Address reviewer comments
   - Keep the PR focused and small
   - Ensure CI passes

## Release Process

Releases are handled automatically by our CI/CD pipeline:

1. **Automatic Version Management:**
   - When changes are pushed to `main`, the CI automatically determines if a new release is needed
   - Version numbers are automatically incremented based on changes
   - You can skip release creation by including `[no-release]` in your commit message

2. **Release Creation:**
   The CI will automatically:
   - Run all tests
   - Build platform-specific packages
   - Create a GitHub release
   - Upload artifacts

For details on package signing and verification, please refer to our [Security Policy](SECURITY.md).

## Getting Help

- Open an issue for bugs or feature requests
- Join our community discussions
- Check existing documentation and issues

## Code of Conduct

We are committed to providing a welcoming and inclusive environment. Please:

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Project Structure

```
keyboards/
├── .github/workflows/    # CI/CD configuration
├── android/              # Android keyboard implementation
├── linux/                # Linux keyboard implementation
├── mac/                  # macOS keyboard implementation
└── windows/              # Windows keyboard implementation
```
