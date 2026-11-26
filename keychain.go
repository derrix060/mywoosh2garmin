package main

import "github.com/zalando/go-keyring"

const (
	keyringService  = "mywhoosh2garmin"
	keyringMyWhoosh = "mywhoosh"
	keyringGarmin   = "garmin"
)

func loadPassword(account string) string {
	pw, _ := keyring.Get(keyringService, account)
	return pw
}

func savePassword(account, password string) error {
	if password == "" {
		return nil
	}
	return keyring.Set(keyringService, account, password)
}

func deletePasswords() {
	_ = keyring.Delete(keyringService, keyringMyWhoosh)
	_ = keyring.Delete(keyringService, keyringGarmin)
}
