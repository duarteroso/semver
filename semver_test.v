module vsemver

fn test_semver_default() {
	a := SemVer{}
	b := SemVer{
		major: 0
		minor: 0
		patch: 0
	}
	assert a.is_equal(b)
	//
	c := SemVer{
		major: 0
		minor: 1
		patch: 0
	}
	assert !a.is_equal(c)
}

fn test_semver_is_greater() {
	a := SemVer{
		major: 1
		minor: 0
		patch: 0
	}
	b := SemVer{}
	assert a.is_greater(b)
	//
	c := SemVer{
		major: 1
		minor: 1
		patch: 1
	}
	d := SemVer{
		major: 2
		minor: 0
		patch: 1
	}
	assert !c.is_greater(d)
}

fn test_semver_is_equal() {
	a := SemVer{
		major: 2
		minor: 2
		patch: 1
	}
	b := SemVer{
		major: 2
		minor: 2
		patch: 1
	}
	assert a.is_equal(b)
	//
	c := SemVer{}
	assert !a.is_equal(c)
}

fn test_semver_str() {
	mut ver := SemVer{
		major: 2
		minor: 1
		patch: 35
	}
	println(ver.str())
	//
	ver = SemVer{
		major: 1
		minor: 0
		patch: 0
		stage: .beta
	}
	println(ver.str())
	//
	ver = SemVer{
		major: 2019
		minor: 3
		patch: 4
		stage: .rc
		build: 'f32'
	}
	println(ver.str())
}

fn test_compare() {
	a := SemVer{
		major: 1
		minor: 0
		patch: 0
	}
	b := SemVer{
		major: 1
		minor: 1
		patch: 0
	}
	c := SemVer{
		major: 1
		minor: 1
		patch: 0
		stage: .beta
	}
	d := SemVer{
		major: 1
		minor: 1
		patch: 0
		stage: .beta
	}
	//
	assert a.compare(b) == .older
	assert b.compare(a) == .newer
	assert b.compare(c) == .newer
	assert c.compare(d) == .equal
}
