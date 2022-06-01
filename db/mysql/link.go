package mysql

import (
	"database/sql"
	"fmt"

	"github.com/chaos-hip/partmate/db"
	"github.com/chaos-hip/partmate/models"
	"github.com/lithammer/shortuuid/v3"
)

const (
	linkFields    = "link, partID, partCategoryID, partAttachmentID, storageID, storageCategoryID, storageImageID, auto_generated"
	linkTableName = "mate_links"
)

var (
	queryGetLinksByLinkID = fmt.Sprintf(`SELECT
		l2.link AS link,
		l2.partID as partID,
		l2.partCategoryID AS partCategoryID,
		l2.partAttachmentID AS partAttachmentID,
		l2.storageID AS storageID,
		l2.storageCategoryID AS storageCategoryID,
		l2.storageImageID AS storageImageID,
		l2.auto_generated AS auto_generated,
		l2.createdAt AS createdAt
	FROM
		%s l1
	LEFT OUTER JOIN
		%s l2
	ON
		(l2.partID = l1.partID OR (l2.partID IS NULL AND l1.partID IS NULL))
	AND
		(l2.partCategoryID = l1.partCategoryID OR (l2.partCategoryID IS NULL AND l1.partCategoryID IS NULL))
	AND
		(l2.partAttachmentID = l1.partAttachmentID OR (l2.partAttachmentID IS NULL AND l1.partAttachmentID IS NULL))
	AND
		(l2.storageID = l1.storageID OR (l2.storageID IS NULL AND l1.storageID IS NULL))
	AND
		(l2.storageCategoryID = l1.storageCategoryID OR (l2.storageCategoryID IS NULL AND l1.storageCategoryID IS NULL))
	AND
		(l2.storageImageID = l1.storageImageID OR (l2.storageImageID IS NULL AND l1.storageImageID IS NULL))
	WHERE
		l1.link = ?
	ORDER BY
		l2.auto_generated ASC,
		l2.link
	`,
		linkTableName,
		linkTableName,
	)
)

//-- Helpers -----------------------------------------------------------------------------------------------------------

// doCreateLink is a short form that creates a link in a manner that can be directly used
// to write the link into an output's sql.NullString result after creation
func (d *DB) doCreateLink(link models.Link) (sql.NullString, error) {
	var out sql.NullString
	l, err := d.CreateLink(link)
	if err != nil {
		return out, err
	}
	out.String = l.Link
	out.Valid = true
	return out, nil
}

//-- Method implementation ---------------------------------------------------------------------------------------------

// GetLinkByID returns the link with the given ID
// Mainly this is used internally to fetch the DB ID of entities
func (d *DB) GetLinkByID(id string) (*models.Link, error) {
	query := fmt.Sprintf("SELECT %s, createdAt FROM %s WHERE link = ?", linkFields, linkTableName)
	var out models.Link
	if err := d.db.Get(&out, query, id); err != nil {
		if err == sql.ErrNoRows {
			// Nothing found
			return nil, nil
		}
		return nil, fmt.Errorf("failed to fetch link: %w", err)
	}
	return &out, nil
}

// GetLinksByLinkID returns a list of links that have the same target as the given link, denoting all links a specific
// item has in the database
func (d *DB) GetLinksByLinkID(id string) ([]*models.Link, error) {
	out := []*models.Link{}
	if err := d.db.Select(&out, queryGetLinksByLinkID, id); err != nil {
		if err == sql.ErrNoRows {
			// Nothing found
			return nil, nil
		}
		return nil, fmt.Errorf("failed to fetch links: %w", err)
	}
	return out, nil
}

// DeleteLinkByID will delete the link with the given ID
func (d *DB) DeleteLinkByID(linkID string) error {
	query := fmt.Sprintf("DELETE FROM %s WHERE link = ?", linkTableName)
	res, err := d.db.Exec(query, linkID)
	if err != nil {
		return fmt.Errorf("failed to delete link %#v: %w", linkID, err)
	}
	rows, err := res.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to get rows affected by deletion: %w", err)
	}
	if rows == 0 {
		return db.ErrNothingDeleted
	}
	return nil
}

// itemIdCheck checks if an item with the given ID exists in the table
// If if exists, it will just return a NIL error
func (d *DB) itemIdCheck(id int, tableName string) error {
	query := fmt.Sprintf("SELECT COUNT(*) FROM %s WHERE id = ?", tableName)
	var num int
	if err := d.db.Get(&num, query, id); err != nil {
		return fmt.Errorf("failed to check for item existence on %#v: %w", tableName, err)
	}
	if num == 0 {
		return fmt.Errorf("the linked item does not exist (%#v)", tableName)
	}
	return nil
}

// CreateLink creates the link to the given target
// Passing a link with an empty ID will generate a new ID
func (d *DB) CreateLink(link models.Link) (*models.Link, error) {
	if link.Link == "" {
		link.Link = shortuuid.New()
	}
	if link.PartID != nil {
		if err := d.itemIdCheck(*link.PartID, partTableName); err != nil {
			return nil, err
		}
	}
	if link.PartCategoryID != nil {
		if err := d.itemIdCheck(*link.PartCategoryID, partCategoryTableName); err != nil {
			return nil, err
		}
	}
	if link.PartAttachmentID != nil {
		if err := d.itemIdCheck(*link.PartAttachmentID, partAttachmentTableName); err != nil {
			return nil, err
		}
	}
	if link.StorageID != nil {
		if err := d.itemIdCheck(*link.StorageID, storageLocationTableName); err != nil {
			return nil, err
		}
	}
	if link.StorageCategoryID != nil {
		if err := d.itemIdCheck(*link.StorageCategoryID, storageLocationCategoryTableName); err != nil {
			return nil, err
		}
	}
	if link.StorageImageID != nil {
		if err := d.itemIdCheck(*link.StorageImageID, storageLocationImageTableName); err != nil {
			return nil, err
		}
	}

	query := fmt.Sprintf("INSERT INTO %s(%s) VALUES(?, ?, ?, ?, ?, ?, ?, ?)", linkTableName, linkFields)
	if _, err := d.db.Exec(
		query,
		link.Link,
		link.PartID,
		link.PartCategoryID,
		link.PartAttachmentID,
		link.StorageID,
		link.StorageCategoryID,
		link.StorageImageID,
		link.AutoGenerated,
	); err != nil {
		return nil, fmt.Errorf("failed to create link: %w", err)
	}
	return &link, nil
}
