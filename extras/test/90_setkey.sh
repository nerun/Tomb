#!/usr/bin/env zsh

export test_description="Testing set key"

source ./setup

test_export "test" # Using already generated tomb
test_expect_success 'Testing set key' '
    tt forge -f -k $tomb_key_new --tomb-pwd $DUMMYPASS \
        --ignore-swap --unsafe --force &&
    tt setkey -f -k $tomb_key_new $tomb_key $tomb \
        --unsafe --tomb-pwd $DUMMYPASS --tomb-old-pwd $DUMMYPASS &&
    tt open -f -k $tomb_key_new $tomb \
        --unsafe --tomb-pwd $DUMMYPASS &&
    print $DUMMYPASS \
        | gpg --batch --passphrase-fd 0 --no-tty --no-options -d $tomb_key_new \
        | xxd &&
    tt_close
    '

if test_have_prereq GPGRCPT; then
test_export "recipient" # Using already generated tomb
test_expect_success 'Testing tomb with GnuPG keys: setkey' '
    tt forge -f $tomb_key_new -g -r $KEY2 --ignore-swap --unsafe &&
    tt setkey -f -k $tomb_key_new  $tomb_key $tomb -g -r $KEY2 &&
    tt open -f -k $tomb_key_new $tomb -g &&
    tt_close
    '
fi

test_done
