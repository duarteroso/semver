## SemVer

### Description
Semantic version module written for the V language.
The specification followed can be found [here](https://semver.org/)

### Install
`v install duarteroso.semver`

### Usage
```v
import duarteroso.semver

fn main() {
    v := semver.SemVer{
        major: 0
        minor: 1
        patch: 27
        stage: .alpha
        build: '077e06b'
    }
}
```

### Authors
@duarteroso

### License
[2-clause BSD License](https://opensource.org/licenses/BSD-2-Clause)
