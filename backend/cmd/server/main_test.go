package main

import (
	"os"
	"path/filepath"
	"testing"
)

func TestResolveAssetsDir(t *testing.T) {
	originalWD, err := os.Getwd()
	if err != nil {
		t.Fatalf("failed to get cwd: %v", err)
	}
	t.Cleanup(func() { _ = os.Chdir(originalWD) })

	t.Run("prefers ../assets when available", func(t *testing.T) {
		tmp := t.TempDir()
		work := filepath.Join(tmp, "backend")
		if err := os.MkdirAll(filepath.Join(tmp, "assets"), 0o755); err != nil {
			t.Fatalf("failed to create assets dir: %v", err)
		}
		if err := os.MkdirAll(work, 0o755); err != nil {
			t.Fatalf("failed to create work dir: %v", err)
		}
		if err := os.Chdir(work); err != nil {
			t.Fatalf("failed to chdir: %v", err)
		}

		got := resolveAssetsDir()
		if got != "../assets" {
			t.Fatalf("expected ../assets, got %s", got)
		}
	})

	t.Run("falls back to assets when ../assets missing", func(t *testing.T) {
		tmp := t.TempDir()
		work := filepath.Join(tmp, "project")
		if err := os.MkdirAll(filepath.Join(work, "assets"), 0o755); err != nil {
			t.Fatalf("failed to create assets dir: %v", err)
		}
		if err := os.Chdir(work); err != nil {
			t.Fatalf("failed to chdir: %v", err)
		}

		got := resolveAssetsDir()
		if got != "assets" {
			t.Fatalf("expected assets, got %s", got)
		}
	})
}
