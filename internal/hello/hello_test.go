package hello

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestHello(t *testing.T) {
	assert.Equal(t, Hello("world"), "Hello, world!")
}
