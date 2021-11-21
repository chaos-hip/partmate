package mysql

import (
	"database/sql"
	"fmt"

	"git.chaos-hip.de/RepairCafe/PartMATE/models"
)

const (
	partAttachmentTableName = "PartAttachment"
)

var (
	queryGetAttachmentByLink = fmt.Sprintf(`SELECT
		attachments.id AS id,
		attachments.part_id AS part_id,
		attachments.type AS type,
		attachments.filename AS filename,
		attachments.originalname AS originalname,
		attachments.mimetype AS mimetype,
		attachments.size AS size,
		attachments.extension AS extension,
		attachments.description AS description,
		attachments.isImage AS isImage
	FROM
		%s AS links
	LEFT OUTER JOIN
		%s AS attachments
	ON
		attachments.id = links.partAttachmentID
	WHERE
		links.link = ?
	AND
		attachments.id IS NOT NULL`,
		linkTableName,
		partAttachmentTableName,
	)
)

func (d *DB) CreatePartAttachmentEntry(partID, filename, mimeType string) (*models.PartAttachment, error) {
	return nil, fmt.Errorf("not implemented")
}

func (d *DB) GetAttachmentEntry(id string) (*models.PartAttachment, error) {
	var res models.PartAttachment
	if err := d.db.Get(&res, queryGetAttachmentByLink, id); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("failed to retrieve attachment by ID: %w", err)
	}
	res.BaseDir = d.dataDir
	return &res, nil
}
