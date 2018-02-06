# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
-
## [1.1.3] - 2018-02-06

### Added
- Add new function to create branch `New-CreateBranch`

### Changed
-some of output variables
s
## [1.1.2] - 2017-12-07

- Few changes in manifest and readme for uploading on psgallery

## [1.0.1] - 2017-11-03
### Added
- New options for `New-BitBucketRepo` 
Create repo with gitflow branch, set default branch, set branch permission 
- `Set-BranchPermission` cmdlet
- `Set-DeafultBranch` cmdlet
- `Set-UserFullNameAndEmail` cmdlet - This is required in order to get correct user display name while commit
- Update wiki page for all feature
- More info about these changes in [Readme.md][wiki]

### Changed
- None

### Removed
- None

## 1.0.0 - 2017-11-01
### Added
- Initial commit of my work, includes below cmdlet to start with
1. `Set-BitBucketServer`
2. `Get-BitBucketServer`
3. `Set-BitBucketCredential`
4. `Get-BitBucketAllRepo`
5. `Get-BitBucketRepoByProject`
6. `Get-BitBucketProjects`
7. `Get-BitBucketRepoSizeByProject`
8. `Get-BitBucketAllRepoSize`
9. `New-BitBucketRepo`

[wiki]: https://github.com/i9shankar/ps-bitbucket/blob/master/README.md