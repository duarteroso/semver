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

// Get string
pub fn (sv &SemVer) str() string {
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

pub fn (sv &SemVer) is_greater(other SemVer) bool {
	if sv.is_equal(other) {
		return false
	}
	//
	res := SemVer{
		major: sv.major - other.major
		minor: sv.minor - other.minor
		patch: sv.patch - other.patch
	}
	return (res.major > 0) || (res.major == 0 && res.minor > 0)
		|| (res.major == 0 && res.minor == 0 && res.patch > 0)
		|| (res.major == 0 && res.minor == 0 && res.patch == 0 && int(sv.stage) > int(other.stage))
}

pub fn (sv &SemVer) is_equal(other SemVer) bool {
	return (sv.major == other.major) && (sv.minor == other.minor) && (sv.patch == other.patch)
		&& (sv.stage == other.stage)
}

// compare returns the relationship between the two versions
pub fn (sv &SemVer) compare(other &SemVer) VersionTime {
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
