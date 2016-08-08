package main

import "testing"

func TestReadFile(t *testing.T) {
	users, err := readFile("users.json")
	if err != nil {
		t.Error(err)
	}
	if len(users) != 3 {
		t.Errorf("expected 3 users received %v", len(users))
	}
}
