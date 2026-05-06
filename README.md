# ZenLang Compiler

ZenLang is a mini compiler project built using **Flex** and **Bison** for Compiler Design.  
It supports variable declarations, arithmetic operations, conditions, loops, input/output, intermediate code generation, optimization, and C code generation.

---

# Features

## Supported Data Types

- `num` → integer
- `dec` → decimal/float
- `text` → string
- `flag` → boolean-like integer

---

# Supported Operations

## Arithmetic Operators

```zen
+
-
*
/
%
```

## Relational Operators

```zen
<
>
<=
>=
is
is not
```

## Logical Operators

```zen
and
or
not
```

---

# Supported Statements

## Variable Declaration

```zen
num a = 5;
dec b = 4.5;
text name = "ZenLang";
```

## Input

```zen
ask a;
```

## Output

```zen
show a;
show "hello\n";
```

## If-Else

```zen
if (a < b) {
    show a;
}
else {
    show b;
}
```

## Loop

```zen
loop (a < 10) {
    show a;
    a = a + 1;
}
```

## Comments

```zen
# this is comment
```

---

# Compiler Phases Implemented

- Lexical Analysis
- Syntax Analysis
- Semantic Analysis
- Symbol Table Management
- Intermediate Code Generation (3AC)
- Optimization (Constant Folding)
- Target Code Generation (C)

---

# Project Structure

```text
ZenLang/
│
├── src/
│   ├── lexer.l
│   ├── parser.y
│   ├── symbol_table.c
│   ├── icg.c
│   ├── optimizer.c
│   └── codegen.c
│
├── include/
│   ├── symbol_table.h
│   ├── icg.h
│   ├── optimizer.h
│   └── codegen.h
│
├── output/
│   ├── output.c
│   └── program.exe
│
├── test/
│   └── sample.zen
│
├── Makefile
└── README.md
```

---

# Requirements

- GCC
- Flex
- Bison
- Make

---

# Build & Run

## Compile

```bash
make all
```

## Run Compiler + Generated Program

```bash
make all run
```

## Clean Generated Files

```bash
make clean
```

---

# Example ZenLang Program

```zen
text title = "ZenLang Compiler\n";

show title;

num a = 5;
num b = 10;

if (a < b) {
    show "a is smaller\n";
}

loop (a < 8) {
    show a;
    a = a + 1;
}
```

---

# Example Output

```text
ZenLang Compiler
a is smaller
5
6
7
```

---

# Optimization Example

## Before Optimization

```text
t0 = 2 * 3
t1 = 4 * 5
```

## After Optimization

```text
t0 = 6
t1 = 20
```

---

# Future Improvements

- Functions
- Arrays
- Better Type Checking
- Scope Management
- Boolean Literals
- Advanced Optimizations
- AST Generation

---

# Author

Love Sharma
