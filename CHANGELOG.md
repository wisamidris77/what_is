# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2025-12-20

### 🚀 New Features

#### 🎓 Learn It Module
A powerful new way to structure your learning journey tailored for **Windows** and **Android**.
- **Topic Management**: Create, organize, and track specific subjects you want to master.
- **Persistent AI Discussions**: Have ongoing, context-aware conversations about your topics that are saved locally.
- **Trivia & Facts**: Generate AI-powered trivia to reinforce your knowledge on specific subjects.
- *Note: This feature leverages a local SQLite database and is currently not available on the Web version.*

#### 🌍 Multi-Platform Support
**What is** has expanded beyond the desktop!
- **Android Support**: A fully optimized mobile experience, bringing the power of "What is" to your pocket.
- **Web Support**: Access the core features (Assistant, Code, Translate, Explain) directly from your browser.

#### 🤖 Expanded AI Ecosystem
We've integrated major AI providers to give you more choice and power:
- **OpenAI**: Integrated support for models like `gpt-4o-mini`.
- **Claude (Anthropic)**: Direct support for Anthropic's `claude-3-5-sonnet`.
- **DeepSeek**: added support for DeepSeek's powerful coding and chat models.
- **AWS Bedrock**: Secure, enterprise-grade access to Claude models via AWS (supports `Access Key`, `Secret Key`, and `Region` configuration).

### ⚙️ Improvements
- **Onboarding Experience**: completely redesigned onboarding flow to let you choose your preferred AI provider and language right from the start.
- **Settings Overhaul**: 
  - Dynamic settings UI that adapts to the selected provider.
  - specialized input fields for complex capabilities (e.g., split fields for AWS Bedrock credentials).
- **Database Architecture**: Migrated to `drift` for robust local data persistence on native platforms.

### 🐛 Fixes
- Fixed `SqliteException(14)` on Windows by ensuring proper creation of the application support directory.
- Resolved various linting issues in the new provider implementations.
