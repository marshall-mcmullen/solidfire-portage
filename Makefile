EBUILD=FEATURES=-userpriv ebuild

.PHONY: sync
sync:
	emerge --sync

.PHONY: shell
shell: sync
	bash

.PHONY: digest
digest: sync
	for fname in $$(git ls-files --others --modified | grep "\.ebuild$$"); do \
		${EBUILD} $${fname} digest; \
	done

.PHONY: digest-all
digest-all: sync
	for dname in */*; do                         				\
		fname=$$(ls $${dname}/*.ebuild 2>/dev/null | head -1); 	\
		[[ -n $${fname} ]] && ${EBUILD} $${fname} digest;   	\
	done

.PHONY: install
install: sync
	for fname in $$(git ls-files --others --modified | grep "\.ebuild$$"); do \
		${EBUILD} $${fname} digest install || exit 1; \
	done

