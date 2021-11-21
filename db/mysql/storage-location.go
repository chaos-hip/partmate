package mysql

import (
	"fmt"

	"git.chaos-hip.de/RepairCafe/PartMATE/models"
	"github.com/jmoiron/sqlx"
)

const (
	storageLocationTableName = "StorageLocation"
)

var (
	queryGetStorageByIDs = fmt.Sprintf(`SELECT
		storage.id AS id,
		storage.name AS name,
		links.link AS link
	FROM
		%s AS storage
	LEFT OUTER JOIN
		%s AS links
	ON
		links.link = (SELECT link FROM %s AS l2 WHERE l2.storageID = storage.id ORDER BY l2.auto_generated LIMIT 1)
	WHERE
		storage.id IN (?);`,
		storageLocationTableName,
		linkTableName,
		linkTableName,
	)
)

// getStorageLocationsByIDs returns the locations matching the IDs given
func (d *DB) getStorageLocationsByIDs(ids []int) ([]models.StorageLocation, error) {
	// Remap the IDs
	var inputArgs []interface{}
	for _, id := range ids {
		inputArgs = append(inputArgs, id)
	}
	res := []*models.StorageLocation{}
	query, args, err := sqlx.In(queryGetStorageByIDs, inputArgs)
	if err != nil {
		return nil, fmt.Errorf("failed to spread IN query")
	}
	query = d.db.Rebind(query)
	if err := d.db.Select(&res, query, args...); err != nil {
		return nil, fmt.Errorf("failed to load storage locations: %w", err)
	}
	out := []models.StorageLocation{}
	// Create links for all the storage locations that have none
	for _, loc := range res {
		if !loc.Link.Valid {
			l, err := d.CreateLink(models.Link{StorageID: &loc.ID, AutoGenerated: true})
			if err != nil {
				return nil, fmt.Errorf("failed to create link for storage location %#v: %w", loc.Name, err)
			}
			loc.Link.String = l.Link
			loc.Link.Valid = true
		}
		out = append(out, *loc)
	}
	return out, nil
}
