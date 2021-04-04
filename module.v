module semver

import v.vmod

// manifest of module
pub fn manifest() ?vmod.Manifest {
	return vmod.decode(@VMOD_FILE)
}
