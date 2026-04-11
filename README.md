# Query Formula

<p align="center">
  <strong>A compact Business Central AL extension for defining reusable query formulas over application tables.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/AL-Runtime%2016.0-0f766e?style=for-the-badge" alt="AL Runtime 16.0" />
  <img src="https://img.shields.io/badge/Business%20Central-Application%2027.0-1d4ed8?style=for-the-badge" alt="Business Central Application 27.0" />
</p>

---

## Overview

Query Formula is a metadata-driven AL extension that lets you define lightweight query rules directly in Business Central.

Each formula is built from three parts:

1. A target table
2. A set of reusable filters and parameters attached to the formula
3. A result strategy such as `Count`, `Sum`, `Average`, `First`, `Last`, `Max`, `Min`, or `List`

The repository currently provides the data model, pages, enums, and permission set needed to maintain those formulas inside Business Central.

## Why This Exists

This app gives you a single place to create and execute queries on BC data without coding and directly from BC Client:

- Define a formula.
- Target a table and set filters per table field.
- You can use the setup as a low level dependency for any user friendly use case that requires freedom of querying any data.

## Supported Concepts

### Query Types

- `Count`
- `Sum`
- `Average`
- `First`
- `Last`
- `Max`
- `Min`
- `List`

### Filter Types

- `Less Than`
- `Less Than or Equal`
- `Greater Than`
- `Greater Than or Equal`
- `Between`
- `Filter`

## Current Scope

This repository is focused on formula definition and maintenance.

It does **not** currently include a query execution engine, posting logic, or API layer. That is important because the project already has a clean configuration surface, but the runtime behavior that consumes these formulas would still need to be implemented in a codeunit or service layer.

## Development Notes

### App metadata

- Name: `Query Formula`
- Publisher: `TransPerEn`
- Version: `27.5.1.6`
- Runtime: `16.0`
- Application: `27.0.0.0`
- ID Range: `51100..51149`

### Local workflow

1. Download symbols for your Business Central target.
2. Build the AL project.
3. Publish the extension to a sandbox.
4. Open `Query Formula List` and maintain formulas from there.

## Suggested Next Step

The next logical addition is an execution codeunit that reads a stored formula, applies its filters and parameters, and returns the requested result in a consistent way.

---

<p align="center">
  Built as a clean foundation for metadata-driven querying in Business Central.
</p>