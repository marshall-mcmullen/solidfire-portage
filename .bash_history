hgs
hg pull -u
vi dev-util/bashutils-solidfire/bashutils-solidfire-0.8.2.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-0.8.2.ebuild digest
hgs
hg commit -m "Pull bashutils 32da4cb58269"
hg push
make push
rsync -avzh . marshall@caprica:/home/marshall/sandboxes/portage
hg pull -u
hg copy dev-util/bashutils-solidfire/bashutils-solidfire-0.8.23.ebuild dev-util/bashutils-solidfire/bashutils-solidfire-0.8.24.ebuild
vi dev-util/bashutils-solidfire/bashutils-solidfire-0.8.24.ebuild
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-0.8.24.ebuild digest
hg commit -m "Pull bashutils d7014fe84c01"
hg push
hg pull -u
hg up -C
hgs
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.2.ebuild 
hgs
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.2.ebuild digest
hg commit -m "Update bashutils-1.0.2 to ebe574da11fe"
hg push
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.12.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.12.ebuild digest
hg commit -m "Bump bashutils to 686ecc92f48a"
hg push
hg pull
hg diff
hg merge
hgs
hg diff
hgs
hg up -C
hgs
hg up -C
hg rollback
hgs
hg log
eix catalyst
cd dev-util/
mkdir catalyst-solidfire
cd catalyst-solidfire/
cat dev-util/bashutils-solidfire/bashutils-solidfire-1.0.12.ebuild 
hg up
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.12.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.12.ebuild digest
hg commit -m "Update bashutils-1.0.12 to ac73e5dba6f7"
hg push
hg in
hgs
hg up -C
hg rollback
hgs
hg up -C
hgs
hg clean
hg pull -u
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild 
hgs
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild digest
hg commit -m "Update bashutils-1.0.13 to ac73e5dba6f7"
hg push
hgs
hg in
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild 
hg diff
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild digest
hg commit -m "Bump bashutils-1.0.13 to a3ce87f5db8c"
hg push
hgcacheup portage
hg pull -u
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild 
hgs
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild digest
hg commit -m "Bump bashutils-1.0.13 to 100fae322927"
hg push
su
hgcacheup portage bashutils
hg in
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild digest
hgs
hg commit -m "Update bashutils-1.0.13 to af49479e14e3"
hg push
hgs
hg out
hgcacheup portage
hg in
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild digest
hg commit -m "Bump bashutils-1.0.13 to f6f2adcd5c49"
hg push
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild digest
hg commit -m "Update bashutils-1.0.13 to 7ebbef08e125"
hg push
hg pull -u
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild digest
hg commit -m "Update bashutils-1.0.13 to be7e24f4fe73"
hgs
hg push
hgcacheup portage
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild digest
su
hgs
hg commit -m "Update bashutils-1.0.13 to c061994d9b42"
hg push
hgcacheup bashutils portage
hg in
hg pull -u
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild 
hgs
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild digest
hg commit -m "Bump bashutils testing version."
hgs
hgcacheup bashutils portage
 76             "bufferCacheGB": 16,
 77             "configuredIops": 50000,
 78             "cpuDmaLatency": -1,
 79             "maxIncomingSliceSyncs": 10,
 80             "postCallbackThreadCount": 8,
 81             "sCacheFileCapacity": 100000000,
 82             "sliceFileLogFileCapacity": 5000000000
hg pull -u
hg heads
hg
hg diff
hgs
hg merge
hgs
hg commit -m merge
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild digest
hgs
hg commit -m "Bump bashutils."
hg push
hg pull -u
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild digest
hgs
hg commit -m "Bump bashutils."
hg push
hgcacheup portage
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild digest
hgs
hg commit -m "Update bashutils to 66ea3f2e97df"
hg push
hg pull
hg merge
hgs
hg diff
hgs
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild digest
hgs
hg diff
hg commit -m "merge"
hg push
hg copy dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.0.0.ebuild
hg copy dev-util/bashutils-solidfire/bashutils-solidfire-1.0.13.ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.0.ebuild
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.1.0.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.0.ebuild digest
hgs
hg clean
hgs
hg revert dev-util/distbox-solidfire/
hgs
hg clean
hgs
hg commit -m "Add new bashutils-1.1.0 at changeset 32aafad4cff4"
hg push
su
hgcacheup portage bashutils
su
hg pull -u
hg copy dev-util/bashutils-solidfire/bashutils-solidfire-1.1.1.ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.2.ebuild
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.1.2.ebuild
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.2.ebuild digest
hg commit -m "Add bashutils-1.1.2 at ae89eac8dc05"
hg push
hgcacheup portage
cat ~/.hgrc
hgs
hg diff
hg up -C
vi dev-util/distbox-solidfire/distbox-solidfire-1.16.ebuild 
hgs
hg diff
ebuild dev-util/distbox-solidfire/distbox-solidfire-1.16.ebuild digest
hg commit -m "Update distbox-1.16 changeset. Lower dependency to bashutils-1.1.2 again."
hg push
hgcacheup bashutils portage
hgs
hg pull -u
hg copy dev-util/distbox-solidfire/distbox-solidfire-1.15.ebuild dev-util/distbox-solidfire/distbox-solidfire-1.16.ebuild
hgs
vi dev-util/distbox-solidfire/distbox-solidfire-1.16.ebuild 
hgs
ebuild dev-util/distbox-solidfire/distbox-solidfire-1.16.ebuild digest
hg commit -m "Add distbox-1.16 ebuild."
hg push
vi dev-util/distbox-solidfire/distbox-solidfire-1.16.ebuild 
ebuild dev-util/distbox-solidfire/distbox-solidfire-1.16.ebuild digest
su
hg in
hg copy dev-util/bashutils-solidfire/bashutils-solidfire-1.1.2.ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.3.ebuild 
ls -l /dev/null
su
ls -l /dev/null
hg copy dev-util/bashutils-solidfire/bashutils-solidfire-1.1.2.ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.3.ebuild 
hgs
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.1.3.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.3.ebuild digest
hgs
hg commit -m "Publish new bashutils-1.1.3 with fixes for tryrc and eretry if /dev/stdout or /dev/stderr are dead symlinks."
hg push
ls -l /dev/std
ls -l /dev/stdo
ls -l /dev/stdout
su
hg push
hg push --verbose
hg push -v --debug
hg push -v --debug --traceback
su
hgs
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.1.3.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.3.ebuild digest
hgs
hg commit -m 'Add new bashutils-solidfire-1.1.13."
hg commit -m 'Add new bashutils-solidfire-1.1.3.'
hg push
distbox shell
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.1.3.ebuild 
hgs
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.3.ebuild digest
hg commit -m "Update bashutils revision."
hg push
hg pull -u
hg copy dev-util/bashutils-solidfire/bashutils-solidfire-1.1.4.ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.5.ebuild
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.1.5.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.5.ebuild digest
hg commit -m "Publish new bashutils-1.1.5 at 00cf29819ff1"
hg push
hg copy dev-util/bashutils-solidfire/bashutils-solidfire-1.1.5.ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.6.ebuild
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.1.6.ebuild 
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.6.ebuild digest
hg commit -m "Update bashutils 1.1.6 to 30693c0f3ac9"
hg push'
hg push
hg pull -u
hgs
ebuild ./dev-util/distbox-solidfire/distbox-solidfire-1.19.ebuild digest
hg commit -m "Fix missing digest files."
hg push
hgcacheup portage
hg pull -u
hg copy dev-util/bashutils-solidfire/bashutils-solidfire-1.1.9.ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.10.ebuild 
vi dev-util/bashutils-solidfire/bashutils-solidfire-1.1.10.ebuild 
hgs
ebuild dev-util/bashutils-solidfire/bashutils-solidfire-1.1.10.ebuild digest
hg commit -m "Create new bashutils-1.1.10 at 233bc34ea21e"
hg push
hgs
ls eclass/
