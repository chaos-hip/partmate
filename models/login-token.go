package models

import (
	"database/sql"
	"time"
)

// LoginToken represents a token that can be used instead of login credentials to log a user in
type LoginToken struct {
	Token                string       `db:"token"`
	Username             string       `db:"username"`
	ExpiresAt            sql.NullTime `db:"expiresAt"`
	SessionLengthSeconds uint64       `db:"sessionLength"`
}

// ToDTO converts the LoginToken to its DTO representation
func (t *LoginToken) ToDTO() LoginTokenDTO {
	out := LoginTokenDTO{
		Token:                t.Token,
		Username:             t.Username,
		SessionLengthSeconds: t.SessionLengthSeconds,
	}
	if t.ExpiresAt.Valid {
		val := t.ExpiresAt.Time.UnixMilli()
		out.ExpiresAt = &val
	}
	return out
}

type LoginTokenDTO struct {
	Token                string `json:"token"`
	Username             string `json:"username"`
	ExpiresAt            *int64 `json:"expiresAt,omitempty"`
	SessionLengthSeconds uint64 `json:"sessionLength"`
}

// ToLoginToken converts the DTO to a login token
func (t *LoginTokenDTO) ToLoginToken() LoginToken {
	out := LoginToken{
		Token:                t.Token,
		Username:             t.Username,
		SessionLengthSeconds: t.SessionLengthSeconds,
	}
	if t.ExpiresAt != nil {
		out.ExpiresAt.Time = time.UnixMilli(*t.ExpiresAt)
		out.ExpiresAt.Valid = true
	}
	return out
}
