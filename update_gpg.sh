#!/usr/bin/env bash
#
# -----------------------------------------------------------------------------
# update_gpg - update your GPG keyring
# -----------------------------------------------------------------------------
#
# (c) Copyright 2007 Nicolas Cavigneaux. All Rights Reserved.

echo ""
echo "Updating GnuPG keyring:"
echo ""
for i in $(/usr/bin/gpg --list-keys | grep '^pub' | cut -c 13-20); do
	/usr/bin/gpg --keyserver keys.pgpi.net --recv-key $i;
done
echo ""
echo "GnuPG keyring updated"