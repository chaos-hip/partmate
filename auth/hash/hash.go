package hash

import (
	"bytes"
	"crypto/rand"
	"encoding/base64"
	"fmt"
	"regexp"
	"strconv"
	"strings"

	"github.com/sirupsen/logrus"
	"golang.org/x/crypto/argon2"
)

const (
	defaultSaltLength  = 32
	defaultKeyLength   = 64
	defaultMemory      = 64 * 1024
	defaultIterations  = 3
	defaultParallelism = 3
)

var argonRegex = regexp.MustCompile(`^argon2id\|[0-9]+\|[0-9]+\|[0-9]+\|[0-9]+\|[a-z,A-Z,+,/,0-9]+\|[a-z,A-Z,+,/,0-9]+$`)

type Hash interface {
	String() string
	// HashPassword creates a new password hash for the given password, using the parameters from this hash
	// (including salt)
	HashPassword(string) (Hash, error)
	// Matches checks if the given password corresponds to the hash
	Matches(string) bool
}

// Argon represents a password has created using Argon2ID key derivation
type Argon struct {
	Memory      uint32
	Iterations  uint32
	Parallelism uint8
	Salt        []byte
	Key         []byte
}

// NewArgon uses the given password and creates its hashed version - using the default parameters
// and a newly generated salt
func NewArgon(password string) (Hash, error) {
	hash := &Argon{
		Memory:      defaultMemory,
		Iterations:  defaultIterations,
		Parallelism: defaultParallelism,
	}
	return hash.HashPassword(password)
}

func newArgonFromHashString(str string) (*Argon, error) {
	parts := strings.Split(str, "|")
	// We don't need to check the length here, since the RegEx already does this for us
	out := &Argon{}
	// Memory
	tmp, err := strconv.ParseUint(parts[2], 10, 32)
	if err != nil {
		return nil, fmt.Errorf("failed to decode 'memory' param from hash string: %w", err)
	}
	out.Memory = uint32(tmp)
	// Iterations
	tmp, err = strconv.ParseUint(parts[3], 10, 32)
	if err != nil {
		return nil, fmt.Errorf("failed to decode 'iterations' param from hash string: %w", err)
	}
	out.Iterations = uint32(tmp)
	// Parallelism
	tmp, err = strconv.ParseUint(parts[4], 10, 8)
	if err != nil {
		return nil, fmt.Errorf("failed to decode 'parallelism' param from hash string: %w", err)
	}
	out.Parallelism = uint8(tmp)
	// Salt
	data, err := base64.RawStdEncoding.Strict().DecodeString(parts[5])
	if err != nil {
		return nil, fmt.Errorf("failed to decode salt from hash string: %w", err)
	}
	out.Salt = data
	// Key
	data, err = base64.RawStdEncoding.Strict().DecodeString(parts[6])
	if err != nil {
		return nil, fmt.Errorf("failed to decode key from hash string: %w", err)
	}
	out.Key = data
	return out, nil
}

// FromString tries to read a hashed password from its string representation
// The stored hash has to be encoded by any of the functions supported by PartMATE (currently Argon2ID)
func FromString(str string) (Hash, error) {
	switch {
	case argonRegex.MatchString(str):
		return newArgonFromHashString(str)
	default:
		return nil, fmt.Errorf("unknown or illegal hash string - no matching hashing algorithm found for %#v", str)
	}
}

func (a *Argon) String() string {
	// Type | Version | Memory | Iterations | Parallelism | Salt (base64) | Hash (=key;base64)
	return fmt.Sprintf(
		"argon2id|%d|%d|%d|%d|%s|%s",
		argon2.Version,
		a.Memory,
		a.Iterations,
		a.Parallelism,
		base64.RawStdEncoding.EncodeToString(a.Salt),
		base64.RawStdEncoding.EncodeToString(a.Key),
	)
}

// HashPassword creates a new password hash for the given password, using the parameters from this hash
// (including salt)
func (a *Argon) HashPassword(password string) (Hash, error) {
	out := &Argon{
		Memory:      a.Memory,
		Iterations:  a.Iterations,
		Parallelism: a.Parallelism,
		Salt:        a.Salt,
	}
	keyLen := uint32(len(a.Key))
	if keyLen == 0 {
		keyLen = defaultKeyLength
	}
	if len(a.Salt) == 0 {
		// Generate a new salt
		salt, err := generateRandomBytes(defaultSaltLength)
		if err != nil {
			return nil, fmt.Errorf("failed to generate salt for password hashing: %w", err)
		}
		out.Salt = salt
		// We won't set our own salt here
	}
	// Generate the key
	out.Key = argon2.IDKey([]byte(password), out.Salt, out.Iterations, out.Memory, out.Parallelism, keyLen)
	return out, nil
}

// Matches checks if the given password corresponds to the hash
func (a *Argon) Matches(password string) bool {
	otherHash, err := a.HashPassword(password)
	if err != nil {
		logrus.WithError(err).Error("Failed to hash password for comparison")
		return false
	}
	b := otherHash.(*Argon)
	return bytes.Equal(a.Key, b.Key)
}

//-- Helpers -----------------------------------------------------------------------------------------------------------

func generateRandomBytes(n uint32) ([]byte, error) {
	b := make([]byte, n)
	_, err := rand.Read(b)
	if err != nil {
		return nil, err
	}

	return b, nil
}
