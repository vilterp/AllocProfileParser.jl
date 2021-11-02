# Alloc Profile Parser

## Usage

### 1. Gather Profile

Using Julia on [this branch](https://github.com/JuliaLang/julia/pull/42768):
```julia
GC.start_alloc_profile(100_000)

# code you wanna profile

file = open("my-profile.json", "w")
GC.stop_and_write_alloc_profile(file)
```

### 2. Parse & Visualize

```julia
prof = AllocProfileParser.parse_alloc_profile("my-profile.json")
AllocProfileParser.to_pprof(prof)
```
