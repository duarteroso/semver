module semver

pub enum Stage {
	alpha
	beta
	rc
	release
}

pub enum VersionTime {
	newer
	equal
	older
}

pub struct SemVer {
pub mut:
	major int
	minor int
	patch int
	stage Stage = .release
	build string
}

pub fn from_string(version string) ?SemVer {
	mut ver := SemVer{}
	//
	mut parts := version.split('+')
	if parts.len == 2 {
		ver.build = parts[1]
	}
	//
	parts = parts[0].split('-')
	if parts.len == 2 {
		stage := parts[1].to_lower()
		ver.stage = match stage {
			'alpha' { Stage.alpha }
			'beta' { Stage.beta }
			'rc' { Stage.rc }
			else { Stage.release }
		}
	}
	//
	parts = parts[0].split('.')
	if parts.len == 0 || parts.len > 3 {
		return error('Invalid format. Use major.minor.patch.state.build')
	}
	//
	mut idx := 0
	if parts.len > idx {
		ver.major = parts[idx].int()
	}
	//
	idx += 1
	if parts.len > idx {
		ver.minor = parts[idx].int()
	}
	//
	idx += 1
	if parts.len > idx {
		ver.patch = parts[idx].int()
	}
	//
	return ver
}

// Get string
pub fn (sv SemVer) str() string {
	mut semver := sv.major.str()
	semver += '.'
	semver += sv.minor.str()
	semver += '.'
	semver += sv.patch.str()
	//
	if sv.stage != .release {
		semver += '-'
		match sv.stage {
			.alpha {
				semver += 'alpha'
			}
			.beta {
				semver += 'beta'
			}
			.rc {
				semver += 'rc'
			}
			else {
				// TODO: Handle better
				assert false
			}
		}
	}
	//
	if sv.build.len != 0 {
		semver += '+'
		semver += sv.build
	}
	//
	return semver
}

pub fn (left SemVer) < (right SemVer) bool {
	if left == right {
		return false
	}
	//
	res := SemVer{
		major: right.major - left.major
		minor: right.minor - left.minor
		patch: right.patch - left.patch
	}
	return (res.major > 0) || (res.major == 0 && res.minor > 0)
		|| (res.major == 0 && res.minor == 0 && res.patch > 0) || (res.major == 0 && res.minor == 0
		&& res.patch == 0 && int(right.stage) > int(left.stage))
}

pub fn (left SemVer) == (right SemVer) bool {
	return (left.major == right.major) && (left.minor == right.minor) && (left.patch == right.patch)
		&& (left.stage == right.stage)
}

// compare returns the relationship between the two versions
pub fn (sv SemVer) compare(other SemVer) VersionTime {
	if sv.major < other.major {
		return VersionTime.older
	} else if sv.major > other.major {
		return VersionTime.newer
	}
	//
	if sv.minor < other.minor {
		return VersionTime.older
	} else if sv.minor > other.minor {
		return VersionTime.newer
	}
	//
	if sv.patch < other.patch {
		return VersionTime.older
	} else if sv.patch > other.patch {
		return VersionTime.newer
	}
	//
	if int(sv.stage) < int(other.stage) {
		return VersionTime.older
	} else if int(sv.stage) > int(other.stage) {
		return VersionTime.newer
	}
	//
	return VersionTime.equal
}
