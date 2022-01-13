package mysql

import (
	"database/sql"
	"errors"
	"fmt"

	"git.chaos-hip.de/RepairCafe/PartMATE/models"
)

const (
	loginTokensTableName = "mate_login_tokens"
)

var (
	queryListLoginTokensForUser = fmt.Sprintf(`SELECT
		tokens.token AS token,
		tokens.username AS username,
		tokens.expiresAt AS expiresAt,
		tokens.sessionLength AS sessionLength
	FROM
		%s AS tokens
	WHERE
		tokens.username = ?`,
		loginTokensTableName,
	)

	whereTokenNotExpired = `
	AND
		(tokens.expiresAt IS NULL OR tokens.expiresAt >= NOW())`

	queryGetNonExpiredTokenByID = fmt.Sprintf(`SELECT
		tokens.token AS token,
		tokens.username AS username,
		tokens.expiresAt AS expiresAt,
		tokens.sessionLength AS sessionLength
	FROM
		%s AS tokens
	WHERE
		tokens.token = ?
	%s`,
		loginTokensTableName,
		whereTokenNotExpired,
	)

	queryCreateLoginToken = fmt.Sprintf(`INSERT INTO
		%s
	SET
		token = ?,
		username = ?,
		expiresAt = ?,
		sessionLength = ?`,
		loginTokensTableName,
	)
)

// List all existing login tokens for a given user - optionally returning the expired ones as well
func (d *DB) ListLoginTokensForUser(username string, expired bool) ([]models.LoginToken, error) {
	query := queryListLoginTokensForUser
	if !expired {
		query += whereTokenNotExpired
	}
	res := []models.LoginToken{}
	if err := d.db.Select(&res, query, username); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return []models.LoginToken{}, nil
		}
		return nil, fmt.Errorf("failed to fetch list of login tokens: %w", err)
	}
	return res, nil
}

// GetNonExpiredLoginTokenByID returns the given login token model if it exists and is not expired yet
func (d *DB) GetNonExpiredLoginTokenByID(id string) (*models.LoginToken, error) {
	res := models.LoginToken{}
	if err := d.db.Get(&res, queryGetNonExpiredTokenByID, id); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, fmt.Errorf("failed to get non-expired login token: %w", err)
	}
	return &res, nil
}

// CreateLoginToken creates a new login token for a user
func (d *DB) CreateLoginToken(token models.LoginToken) error {
	if _, err := d.db.Exec(
		queryCreateLoginToken,
		token.Token,
		token.Username,
		token.ExpiresAt,
		token.SessionLengthSeconds,
	); err != nil {
		return fmt.Errorf("failed to insert  login token: %w", err)
	}
	return nil
}
